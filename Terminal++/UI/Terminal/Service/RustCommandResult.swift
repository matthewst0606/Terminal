//
//  RustCommandResuld.swift
//  Terminal++
//
//  Created by Matt on 7/12/26.
//

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
