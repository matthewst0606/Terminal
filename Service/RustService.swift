//
//  RustService.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import Observation

@Observable
final class RustService {
    static let shared = RustService()
    private init() {}
    
    func execute(_ command: String) -> String {
        return terminal_execute(command).toString()
    }
    
    func history(_ command: String) -> [String] {
        let rustHistory = terminal_history(command)
        return rustHistory.map {
            $0.as_str().toString()
        }
    }
}

