public func terminal_execute<GenericIntoRustString: IntoRustString>(_ command: GenericIntoRustString) -> RustString {
    RustString(ptr: __swift_bridge__$terminal_execute({ let rustString = command.intoRustString(); rustString.isOwned = false; return rustString.ptr }()))
}


