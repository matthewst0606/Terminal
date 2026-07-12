//
//  TerminalTextbox.swift
//  Terminal++
//
//  Created by Matt on 6/30/26.
//
import SwiftUI

struct TerminalTextbox: View {
    @Bindable var terminal: Terminal
    var history: TerminalHistory
    var suggestion: InputSuggestions

    
    
    
    var body: some View {
        Textbox("Enter a command", for: $terminal.input) {
            terminal.submit()
            history.resetIndex()
        }
        .textboxStyle(.glass)
        
        .overlay(alignment: .leading) {
            if let suffix = suggestion.suggestionSuffix {
                
                HStack(content: {
                    Text(terminal.input)
                        .opacity(0)
                    Text(suffix)
                        .foregroundStyle(ColorLib.suggestionText.color)
                })
                .padding(.leading, 8)
                .allowsHitTesting(false)
            }
        }
        .padding(8)
        .shadow(radius: 10)
        
        
//        .overlayStyle(terminal, history)
        .shortcutsModifier(getPrevHistory, getNextHistory)
    }
}

extension TerminalTextbox {
    func getPrevHistory() {
        guard let prev = history.previousCommand() else { return }
        DispatchQueue.main.async {
            self.terminal.input = prev
        }
    }
    func getNextHistory() {
        guard let next = history.nextCommand() else { return }
        DispatchQueue.main.async {
            self.terminal.input = next
        }
    }
}
