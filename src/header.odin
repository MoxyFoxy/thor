package thor

import "core:strconv"
import "core:strings"
import "core:fmt"

Header :: struct {
	method: HttpMethod,
	route: string,
	content_type: Mime_Type,
	accept: string,
	host: string,
	accept_encoding: []Encoding,
	connection: string,
}

Request :: struct {
	header: Header,
	body: string,
}

HttpMethod :: enum {
	Unknown,

	Get,
	Post,
	Put,
	Patch,
	Delete,
	Copy,
	Head,
	Options,
	Link,
	Unlink,
	Purge,
	Lock,
	Unlock,
	Propfind,
	View,
}

string_to_method :: proc(method: string) -> HttpMethod {
	switch method {
		case "GET":      return .Get
		case "POST":     return .Post
		case "PUT":      return .Put
		case "PATCH":    return .Patch
		case "DELETE":   return .Delete
		case "COPY":     return .Copy
		case "HEAD":     return .Head
		case "OPTIONS":  return .Options
		case "LINK":     return .Link
		case "UNLINK":   return .Unlink
		case "PURGE":    return .Purge
		case "LOCK":     return .Lock
		case "UNLOCK":   return .Unlock
		case "PROPFIND": return .Propfind
		case "VIEW":     return .View
	}

	return .Unknown
}

Encoding :: enum {
	Unknown,

	Any,
	GZip,
	Compress,
	Deflate,
	Br,
	ZStd,
	Identity,
}

parse_request :: proc(content: string) -> Request {
	header, content_length, ok := parse_header(content)
	body := content[len(content) - content_length:]

	return Request {
		header,
		body,
	}
}

parse_header :: proc(content: string) -> (header: Header, content_length: int, err: bool) {
	content := content
	err = false

	builder: strings.Builder
	strings.builder_init(&builder)

	{
		method, len := read_until(content, ' ', &builder)
		content = content[len:]
		header.method = string_to_method(method)
	}
	{
		route, len := read_until(content, ' ', &builder, context.allocator)
		content = content[len:]
		header.route = route
	}
	{
		protocol, len := read_until(content, '\r', &builder)
		content = content[len + 1:]
	}

	for {
		if content[0:2] == "\r\n" do break

		name, name_len := read_until(content, ':', &builder)
		defer delete(name)

		content = content[name_len + 1:]

		value, value_len := read_until(content, '\r', &builder, context.allocator)
		content = content[value_len + 1:]

		switch name {
			case "Content-Type":
				header.content_type = content_type_to_mime(value)
			case "Host":
				header.host = value
			case "Accept": // TODO: Multiple values and Q-Factor
				header.accept = value
			case "Connection":
				header.connection = value
			case "Content-Length":
				defer delete(value)
				ok: bool
				content_length, ok = strconv.parse_int(value)

				if !ok {
					err = true
					return
				}
		}
	}

	fmt.println(header)

	return
}

@(private)
read_until :: proc(input: string, until: rune, builder: ^strings.Builder, allocator := context.temp_allocator) -> (output: string, length: int)  {
	strings.builder_reset(builder)

	for char, offset in input {
		if char == until do break
		
		strings.write_rune(builder, char)
		length = offset + 2
	}

	output = strings.to_string(builder^)
	new_str := make([]u8, len(output))
	copy(new_str, output)
	output = cast(string) new_str

	return
}