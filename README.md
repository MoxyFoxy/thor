# Thor - Odin HTTP Server
A WIP for-fun Odin HTTP server. I just wish to learn more about HTTP and how it works.

## Goals
These are all listed in the order of which I want to try to accomplish them. The goal is to have a full HTTP server that can serve either APIs or web pages with or without Odin WASM. This list will expand as I get new ideas or think of things I completely forgot to add.
- [X] MIME Types (Hey I had to give myself at least one check and that was *tedious*)
- [ ] Header Parsing (WIP)
- [ ] Body Unmarshalling
- [ ] Routing
	- [ ] Route Parameters (how I'm going to do this I have *no* idea. Maybe massive preprocessing? I doubt Odin has the reflection for this natively)
- [ ] Figure out the actual architecture I'll use (MVC? Something new? Odin doesn't lend itself well to MVC)
- [ ] Preprocessing (? Might be necessary for removing boilerplate)
	- [ ] Route Preprocessing
	- [ ] MIME Type Preprocessing
- [ ] Middleware
- [ ] Response Functions (Ok, BadRequest, etc.)
	- [ ] Automatically handle some cases such as 404
- [ ] Automatic Response Body Marshaling
- [ ] Server Configuration (TOML)
- [ ] HTML Preprocessing
	- [ ] Variable Injection
	- [ ] Function Injection
	- [ ] Value-Variable Binding
	- [ ] Conditionals
	- [ ] Loops
- [ ] Page Reponses w/ Preprocessing
- [ ] Page Redirection (e.g. errors)
- [ ] Components
- [ ] Odin WASM
- [ ] JavaScript Interop