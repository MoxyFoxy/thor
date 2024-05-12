//+private
package thor

import "core:net"
import "core:log"
import "core:fmt"

// Temporary hack due to compiler bug
IP4_Loopback := net.IP4_Loopback

main :: proc() {
	context.logger = log.create_console_logger()
	fmt.println("Starting server...")
	run_server()
}

run_server :: proc(address: net.Address = IP4_Loopback, port := 8000) -> net.Network_Error {
	endpoint := net.Endpoint {
		address,
		port,
	}

	listen := net.listen_tcp(endpoint) or_return

	fmt.println("Listening...")

	for {
		connection, connection_endpoint := net.accept_tcp(listen) or_return
		handle_request(connection, connection_endpoint)
	}

	return nil
}

handle_request :: proc(connection: net.TCP_Socket, connection_endpoint: net.Endpoint) -> net.Network_Error {
	defer net.close(connection)

	fmt.println("Received request")

	buf: [4096]byte
	length := net.recv_tcp(connection, buf[:]) or_return

	//fmt.println(cast(string) buf[:length])
	//fmt.printfln("Length: %v", length)

	response := parse_request(cast(string) buf[:length])

	return nil
}