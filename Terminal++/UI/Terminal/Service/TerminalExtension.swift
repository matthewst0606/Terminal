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
        UserDefaults.standard.set(history, forKey: "terminalHistory")
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
        output.append(.init(kind: .text(text)))
    }
    
     func outputList(command: String, entries: [DirectoryEntry]) {
        output.append(.init(kind: .listing(entries: entries)))
    }
    
    func outputGitStatus(branch: String, branchStatus: String, entries: [GitStatusEntry]) {
        output.append(.init(kind: .gitStatus(
            branch: branch,
            branchStatus: branchStatus,
            entries: entries
        )))
    }
    
    func outputDockerPs(command: String, entries: [DockerPsEntry]) {
       output.append(.init(kind: .dockePs(entries: entries)))
   }
   
    func outputError(command: String, message: String) {
        output.append(.init(kind: .error(command: command, message: message)))
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
}








