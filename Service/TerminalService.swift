//
//  TerminalService.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//
import Foundation
import Combine

@MainActor
final class TerminalService: ObservableObject {
    @Published var output: String = ""
    @Published var history: [String] = []
    @Published var input: String = ""
    
  
    // textbox submit action
    func submit() {
        output += "\n<User> → \(input)\n"
        output += "\(RustService.shared.execute(input))"
        history.append("\(RustService.shared.history(input))")
        input = ""
    }
}
