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
    var autocomplete: TerminalAutocomplete

    var body: some View {
        Textbox("Enter a command", for: $terminal.input) {
            terminal.submit()
            history.resetIndex()
        }
        .textboxStyle(.glass)
        
        .overlay(alignment: .leading) {
            AutocompleteView(
                terminal: terminal,
                autocomplete: autocomplete
            )
        }
        .padding(8)
        .shadow(radius: 10)
        
        
        .overlayStyle(terminal, history)
        
        .shortcutsModifier(getPrevHistory, getNextHistory)
    }
}



struct AutocompleteView: View {
    @Bindable var terminal: Terminal
    var autocomplete: TerminalAutocomplete
    
    var body: some View {
        if let suffix = autocomplete.predictionSuffix {
            
            HStack(content: {
                Text(terminal.input)
                    .opacity(0)
                Text(suffix)
                    .foregroundStyle(ColorLib.autocompleteText.color)
            })
            .padding(.leading, 8)
            .allowsHitTesting(false)
        }
    }
}
