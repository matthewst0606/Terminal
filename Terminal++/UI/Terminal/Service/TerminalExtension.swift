import AppKit
import SwiftUI
extension Terminal {
    
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
    
     func outputText(_ text: String, prompt: TerminalOutput.Prompt?) {
        output.append(.init(kind: .text(text), prompt: prompt))
    }
    
    func refreshDir() {
        let result = RustService.shared.execute("pwd")

        let parsed = parseResult(result)
        let directory: String?

        switch parsed {
        case .text(let text):
            directory = text
            
        case .external(let stdout, _, let exitCode) where exitCode == 0:
            directory = stdout
            
        default:
            directory = nil
        }

        if let directory {
            currentDir = directory.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
        }
    }
    
    
    // ------- ls output -------
     func outputList(
        command: String,
        entries: [DirectoryEntry],
        prompt: TerminalOutput.Prompt?
    ) {
        output.append(.init(kind: .listing(entries: entries), prompt: prompt))
    }
    
    // ------- git status -------
    func outputGitStatus(
        branch: String,
        branchStatus: String,
        entries: [GitStatusEntry],
        prompt: TerminalOutput.Prompt?
    ) {
        output.append(.init(kind: .gitStatus(
            branch: branch,
            branchStatus: branchStatus,
            entries: entries
        ), prompt: prompt))
    }
    
    // ------- git add -------
    func outputGitAdd(
        added: Int,
        modified: Int,
        deleted: Int,
        prompt: TerminalOutput.Prompt?
    )
    {
        output.append(.init(
            kind: .gitAdd(
                added: added,
                modified: modified,
                deleted: deleted
                
            ), prompt: prompt))
    }
    
    func gitAddSummaryResult(
        rawOutput: String,
        prompt: TerminalOutput.Prompt?
    ) -> GitAddSummary?
    {
        let statusResult = parseResult(RustService.shared.execute("git status --porcelain"))
        guard case
            .external(let stdout, _, let statusExitCode) = statusResult,
            statusExitCode == 0
        else {
            outputText(rawOutput, prompt: prompt)
            return nil
        }
        
        let summary = CommandOutputCustomizer.gitAddSummary(from: stdout)
        
        return summary
    }
    
    
    // ------- docker ps -------
    func outputDockerPs(
        command: String,
        entries: [DockerPsEntry],
        prompt: TerminalOutput.Prompt?
    )
    {
       output.append(.init(kind: .dockePs(entries: entries), prompt: prompt))
    }
   
    // ------- error output -------
    func outputError(
        command: String,
        message: String,
        prompt: TerminalOutput.Prompt?
    ) {
        output.append(.init(kind: .error(command: command, message: message), prompt: prompt))
    }

    
    
    func displayExternalOutput(
        command: String,
        stdout: String,
        stderr: String,
        exitCode: Int?,
        prompt: TerminalOutput.Prompt?
    )
    {
        let rawOutput = stdout + stderr

        guard exitCode == 0 else {
            var message = rawOutput.trimmingCharacters(
                in: .whitespacesAndNewlines
            )
                        
            if message.isEmpty {
                message = "Process exited with status \(exitCode.map(String.init) ?? "unknown")"
            }
            outputError(
                command: command,
                message: message,
                prompt: prompt
            )
            return
        }
        

        
        switch CommandOutputCustomizer.customize(command: command, output: rawOutput) {
            
        case .gitStatus(let branch, let branchStatus, let entries):
            outputGitStatus(
                branch: branch,
                branchStatus: branchStatus,
                entries: entries,
                prompt: prompt
            )
            
        case .gitAdd:
            guard let summary = gitAddSummaryResult(
                rawOutput: rawOutput,
                prompt: prompt
            )
            else { return }

            outputGitAdd(
                added: summary.added,
                modified: summary.modified,
                deleted: summary.deleted,
                prompt: prompt
            )

        case .dockerPs(let entries):
            outputDockerPs(
                command: command,
                entries: entries,
                prompt: prompt
            )
            
        case .text(let text):
            outputText(text, prompt: prompt)
            
        }
    }
    
    
    
    

    
    
    
    

}



