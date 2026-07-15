import Foundation

enum CustomizedCommandOutput {
    case text(String)
    case gitStatus(
        branch: String,
        branchStatus: String,
        entries: [GitStatusEntry]
    )
    case gitAdd
    case dockerPs(
        entries: [DockerPsEntry]
    )
}

enum CommandOutputCustomizer {
    
    
    static func customize(command: String, output: String) -> CustomizedCommandOutput {
        let words = command.split(whereSeparator: { $0.isWhitespace }).map(String.init)

        if words == ["git", "status"], let status = parseGitStatus(output) {
            return status
        }
        
        if words.count >= 2, words[0] == "git", words[1] == "add" {
            return .gitAdd
        }
        
        if words == ["docker", "ps"], let containers = parseDockerPs(output) {
            return .dockerPs(entries: containers)
        }

        return .text(output)
    }

    
    private static func gitStatusDetails(
        from lines: [String]
    ) -> (
        branchStatus: String,
        entries: [GitStatusEntry]
    ) {
        enum Section: Equatable {
            case none, staged, changed, untracked
        }

        var section = Section.none
        var branchStatus = ""
        var entries: [GitStatusEntry] = []

        for line in lines.dropFirst() {
            let trimmed = line.trimmingCharacters(in: .whitespaces)

            if trimmed.hasPrefix("Your branch ") {
                branchStatus = trimmed
                continue
            }

            switch trimmed {
            case "Changes to be committed:":
                section = .staged
                continue
                
            case "Changes not staged for commit:":
                section = .changed
                continue
                
            case "Untracked files:":
                section = .untracked
                continue
                
            default:
                break
            }

            guard !trimmed.isEmpty, !trimmed.hasPrefix("(")
            else { continue }

            switch section {
                
                
            case .staged, .changed:
                guard let separator = trimmed.firstIndex(of: ":")
                else { continue }
                
                let label = trimmed[..<separator]
                let path = trimmed[trimmed.index(after: separator)...]
                    .trimmingCharacters(in: .whitespaces)
                
                guard !path.isEmpty else { continue }

                let status: String
                
                if label == "deleted"      { status = "deleted"  }
                else if section == .staged { status = "staged"   }
                else                       { status = "modified" }
                
                
                entries.append(.init(
                    path: path,
                    status: status
                ))

                
            case .untracked:
                if !trimmed.hasPrefix("nothing added") {
                    entries.append(.init(path: trimmed, status: "untracked"))
                }

            case .none:
                continue
            }
        }
        return (branchStatus: branchStatus, entries: entries)
    }
    
    private static func parseGitStatus(_ output: String) -> CustomizedCommandOutput? {
        let lines = output.components(separatedBy: .newlines)
        
        guard let firstLine = lines.first
        else { return nil }
        
        let branch: String
        
        if firstLine.hasPrefix("On branch ") {
            branch = String(firstLine.dropFirst("On branch ".count))
        }
        
        else if firstLine.hasPrefix("HEAD detached ") {
            branch = String(firstLine.dropFirst("HEAD ".count))
        }
        
        else {
            return nil
        }

        let (branchStatus, entries) = gitStatusDetails(from: lines)
        
        return .gitStatus(
            branch: branch,
            branchStatus: branchStatus,
            entries: entries
        )
    }
    
    
    
    static func gitAddSummary(from output: String) -> GitAddSummary {
        var summary = GitAddSummary()
        
        for line in output.split(whereSeparator: {$0.isNewline}) {
            switch line.first {
            case "A":
                summary.added += 1
            case "M":
                summary.modified += 1
            case "D":
                summary.deleted += 1
            default:
                break
            }
        }
        
        return summary
    }

    private static func parseDockerPs(_ output: String) -> [DockerPsEntry]? {
        let lines = output.split(whereSeparator: { $0.isNewline })
            .map(String.init)
        
        guard let header = lines.first
        else { return nil }

        let columnNames = [
            "CONTAINER ID", 
            "IMAGE",
            "COMMAND",
            "CREATED",
            "STATUS",
            "PORTS",
            "NAMES"
        ]
        
        let headerString = header as NSString
        
        let starts = columnNames
            .map { headerString.range(of: $0).location }
        
        guard !starts.contains(NSNotFound)
        else { return nil }

        func value(_ name: String, in line: String) -> String {
            
            let index = columnNames.firstIndex(of: name)!
            
            let row = line as NSString
            
            let start = min(starts[index], row.length)
            

            
            let end = if index + 1 < starts.count {
                min(starts[index + 1], row.length)
            }
            else {
                row.length
            }
            
            
            
            guard end >= start
            else { return "" }
            
            return row.substring(with: NSRange(
                location: start,
                length: end - start
            ))
            .trimmingCharacters(in: .whitespaces)
        }

        return lines.dropFirst().map { line in
            DockerPsEntry(
                container: value("NAMES", in: line),
                container_id: value("CONTAINER ID", in: line),
                image: value("IMAGE", in: line),
                status: value("STATUS", in: line),
                ports: value("PORTS", in: line)
            )
        }
    }
}
