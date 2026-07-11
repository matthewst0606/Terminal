//
//  TerminalSessionView.swift
//  Terminal++
//
//  Created by Matt on 7/8/26.
//
import SwiftUI

struct OutputBox: View {
    var terminal: Terminal
    var history: TerminalHistory
    var suggestion: InputSuggestions

    init(_ terminal: Terminal, _ history: TerminalHistory, _ suggestion: InputSuggestions) {
        self.terminal = terminal
        self.history = history
        self.suggestion = suggestion
    }
    
    @AppStorage("fontDesign") var selectedFont: FontPicker = .system

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollViewReader { proxy in
                ScrollView {
                    terminalTextOutput
                        .padding(.top, 25)
                        .padding(.bottom, 75)
                        .id("bottom")
                }
                .contentMargins(16, for: .scrollContent)
                .onChange(of: terminal.output) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )

            TerminalTextbox(
                terminal: terminal,
                history: history,
                suggestion: suggestion
            )
        }
    }

    var terminalTextOutput: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(terminal.output) { item in
                switch item.kind {
                
                case .text(let text):
                    Text("\(ANSIParser.attributedString(from: text))")                
                    
                case .listing(let entries):
                    ForEach(entries, id: \.name) { entry in
                        
                        HStack {
                            Button {
                                terminal.submitNoPrompt("cd \(entry.path)")
                                terminal.submitNoPrompt("ls")
                            }
                            label: {
                                
                                if entry.kind == "directory"
                                    { Symbol("folder") }
                                else if entry.kind == "file"
                                    { Symbol("document") }
                                else
                                    { Symbol("questionmark") }
                                
                                
                                Text("\(entry.name)")
                                    .fontWeight(.semibold)

                            }
                            .buttonStyle(.plain)
                            .frame(width: 200, alignment: .leading)
                            
                            
                            Text("\(entry.path)")
                                .font(.system(size: 12, weight: .light))
                                .foregroundStyle(.secondary)
                                

                        }
                    }

                    
                    
                case .error(let command, let message):
                    VStack(alignment: .leading,spacing: 6) {
                        HStack {

                        Symbol("exclamationmark.triangle",render: .palette)

                            Text("Error:")
                                .foregroundStyle(Color(NSColor.systemRed))
                                .fontWeight(.semibold)
                            
                            Text(command)
                                .foregroundStyle(Color(NSColor.systemBlue))
                                .fontWeight(.semibold)
                            
                        }
                        Text(message)
                            .foregroundStyle(.secondary)
                            .fontWeight(.regular)

                    }
                    
                }
            }
        }
        .font(.system(
            size: 14,
            weight: .regular,
            design: selectedFont.design
        ))
        .lineSpacing(2)
        .textSelection(.enabled)
        
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    

}
