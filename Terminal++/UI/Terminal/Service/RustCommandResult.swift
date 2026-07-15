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
    case external(stdout: String, stderr: String, exitCode: Int?)
    case listing (entries: [DirectoryEntry])
    case gitStatus (
        branch: String,
        branchStatus: String,
        entries: [GitStatusEntry],
    )
    case gitAdd (
        added: Int,
        modified: Int,
        deleted: Int
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
    let stdout: String?
    let stderr: String?
    let exit_code: Int?
    
    let branch: String?
    let branch_status: String?
    
    let added: Int?
    let modified: Int?
    let deleted: Int?

    let entries: [DirectoryEntry]?
    let git_status_entries: [GitStatusEntry]?
    let docker_ps_entries: [DockerPsEntry]?
    
    enum Kind: String, Decodable {
        case text
        case external
        case exit
        case clear
        case clearline
        case listing
        case gitStatus = "git_status"
        case gitAdd = "git_add"
        case dockerPs = "docker_ps"
        case error
    }
}
