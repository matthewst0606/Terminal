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
    
    func outputGitStatus(branch: String, branchStatus: String, entries: [GitStatusEntry]) {
        output.append(.init(kind: .gitStatus(
            branch: branch,
            branchStatus: branchStatus,
            entries: entries
        )))
    }
    
    func outputDockerPs(command: String, entries: [DockerPsEntry]) {
       output.append(.init(kind: .dockePs(
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
        
        case .gitStatus:
            return .gitStatus(
                branch: decoded.branch ?? "",
                branchStatus: decoded.branch_status ?? "",
                entries: decoded.git_status_entries ?? []
            )
            
        case .dockerPs:
            return .dockerPs(
                entries: decoded.docker_ps_entries ?? []
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
    case gitStatus (
        branch: String,
        branchStatus: String,
        entries: [GitStatusEntry],
    )
    case dockerPs(entries: [DockerPsEntry])
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
    
    let branch: String?
    let branch_status: String?

    let entries: [DirectoryEntry]?
    let git_status_entries: [GitStatusEntry]?
    let docker_ps_entries: [DockerPsEntry]?
    
    enum Kind: String, Decodable {
        case text
        case exit
        case clear
        case clearline
        case listing
        case gitStatus = "git_status"
        case dockerPs = "docker_ps"
        case error
    }
}

struct DirectoryEntry: Decodable, Equatable {
    let name: String
    let path: String
    let kind: String
}


struct GitStatusEntry: Decodable, Equatable {
    let path: String
    let status: String
}

struct DockerPsEntry: Decodable, Equatable {
    let container: String
    let container_id: String
    let image: String
    let status: String
    let ports: String

    enum CodingKeys: String, CodingKey {
        case container = "Names"
        case container_id = "ID"
        case image = "Image"
        case status = "Status"
        case ports = "Ports"
    }
}
