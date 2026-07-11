import AppKit

extension Terminal {
     func printPrompt(for command: String) {
        terminalPrint("\n>> \(command)\n")
    }
    
     func terminalPrint(_ text: String) {
        output.append(.init(kind: .text(text)))
    }
    
     func appendToHistory(_ command: String) {
        history = RustService.shared.history(command)
        input = ""
    }
    
     func exit() {
        NSApplication.shared.terminate(nil)
    }
    
     func clear() {
        output = []
    }
    
     func clearline() {
        guard !output.isEmpty else { return }
        output = output.dropLast()
    }
    
     func promptUserInput(prompt: Bool, command: String) {
        if prompt { printPrompt(for: command) }
    }
    
     func outputText(_ text: String) {
        output.append(.init(
            kind: .text(text)
        ))
    }
    
     func outputList(command: String, entries: [DirectoryEntry]) {
        output.append(.init(kind: .listing(
            entries: entries
        )))
    }
    
    func outputError(command: String, message: String) {
        output.append(.init(kind: .error(
            command: command,
            message: message
        )))
    }
    
    func refreshDir() {
         currentDir = RustService.shared.execute("pwd")
        
        func refreshDir() {
            let result = RustService.shared.execute("pwd")

            if case .text(let directory) = parseResult(result) {
                currentDir = directory.trimmingCharacters(
                    in: .whitespacesAndNewlines
                )
            }
        }
    }
    
    
    func parseResult(_ result: String) -> CommandResult {
        guard
            let data = result.data(using: .utf8),
            let decoded = try? JSONDecoder()
                .decode(
                    RustCommandResult.self,
                    from: data
                )
        else {
            return .text(result)
        }

        switch decoded.kind {
        case .exit:
            return .exit
        case .clear:
            return .clear
        case .clearline:
            return .clearline
            
            
        case .text:
            return .text(
                decoded.text ?? ""
            )
            
        case .listing:
            return .listing(
                entries: decoded.entries ?? []
            )
            
        case .error:
            return .error(
                command: decoded.command ?? "",
                message: decoded.message ?? ""
            )
        }
    }
}

enum CommandResult {
    case exit
    case clear
    case clearline
    case text(String)
    case listing (entries: [DirectoryEntry])

    case error(
        command: String,
        message: String
    )
}

struct RustCommandResult: Decodable {
    let kind: Kind
    let text: String?
    let command: String?
    let message: String?
    let entries: [DirectoryEntry]?
    
    enum Kind: String, Decodable {
        case text
        case exit
        case clear
        case clearline
        case listing
        case error
    }
}

struct DirectoryEntry: Decodable, Equatable {
    let name: String
    let path: String
    let kind: String
}
