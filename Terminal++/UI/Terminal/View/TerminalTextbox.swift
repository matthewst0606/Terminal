//
//  TerminalTextbox.swift
//  Terminal++
//
//  Created by Matt on 6/30/26.
//
import SwiftUI

struct TerminalTextbox: View {
    @Bindable var terminal: Terminal
    @State private var textboxToggle: Bool = true

    var history: TerminalHistory
    var suggestion: InputSuggestions


    var body: some View {
        VStack {
            if textboxToggle {
                Textbox("Enter a command", for: $terminal.input) {
                    terminal.submit()
                    history.resetIndex()
                }
                .modifier(OverlayTransition(.bottom))
                
            }
        }
        .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 70)
        
        .overlay(alignment: .leading) {
            showTextSuggestion
        }
        .padding(8)
        
        .overlay(alignment: .trailing) {
            
            Button {
                textboxToggle.toggle()
            }
            label: {
                Symbol("chevron.down")
                    .contentShape(.circle)
                    .frame(width: 25, height: 25)
                
            }
            .buttonBorderShape(.circle)
            .padding(.trailing, 25)
        }
        
        .kbShortcut(key: .upArrow,   action: { getPrevHistory() })
        .kbShortcut(key: .downArrow, action: { getPrevHistory() })
        
    }
}


private extension TerminalTextbox {
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
    
    @ViewBuilder
    var showTextSuggestion: some View {
        if let suffix = suggestion.suggestionSuffix {
            
            HStack(content: {
                Text(terminal.input).opacity(0)
                Text(suffix        ).foregroundStyle(Color(nsColor: .tertiaryLabelColor))
            })
            .padding(.leading, 8)
            .allowsHitTesting(false)
        }
    
    }
}
