//
//  TerminalSessionView.swift
//  Terminal++
//
//  Created by Matt on 7/8/26.
//
import SwiftUI
import FileProvider

struct OutputBox: View {
    @AppStorage("fontDesign") var selectedFont: FontPicker = .system
    var terminal: Terminal
    var history: TerminalHistory
    var suggestion: InputSuggestions
    
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
            .scrollIndicators(.hidden)

            TerminalTextbox(
                terminal: terminal,
                history: history,
                suggestion: suggestion
            )
        }
    }
}


extension OutputBox {
    var terminalTextOutput: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(terminal.output) { item in
                
                if let prompt = item.prompt {
                    inputPrompt(prompt: prompt)
                }
                
                switch item.kind {
                case .text(let text):
                    Text("\(ANSIParser.attributedString(from: text))")
                    
                case .listing(let entries):
                    ListingCommandView(terminal: terminal, entries: entries)

                case .gitStatus(let branch, let branchStatus, let entries):
                    GitCommandsView(branch: branch, branchStatus: branchStatus, entries: entries)
                    
                case .gitAdd(let added, let modified, let deleted):
                    GitAddView(added: added, modified: modified, deleted: deleted)
                    
                case .dockePs(let entries):
                    DockerCommandsView(entries: entries)
                    
                case .error(let command, let message):
                    errorFormat(command, message)
                }
            }
        }
        .font(.system(
            size: 14,
            weight: .regular,
            design: selectedFont.design
        ))
        .frame(
            minWidth: 500,
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .lineSpacing(2)
        .textSelection(.enabled)
    }
}


extension OutputBox {
    @ViewBuilder
    func errorFormat(
        _ command: String,
        _ message: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                    
                
                let errorStart = Text("Command")
                    .foregroundStyle(Color(nsColor: .systemRed))
                    .fontWeight(.semibold)
                
                let errorCommand = Text("\"\(command)\"")
                    .foregroundStyle(Color(nsColor: .linkColor))
                    .fontWeight(.semibold)
                
                let errorEnd = Text("not found.")
                    .foregroundStyle(Color(nsColor: .systemRed))
                    .fontWeight(.semibold)
                
                let warningIcon = Text("\(Image(systemName: "exclamationmark.triangle"))")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
                
                let warningMessage = Text(message)
                    .foregroundStyle(.secondary)
                    .fontWeight(.light)
                    
                
                Text(
                    """
                    \(errorStart) \(errorCommand) \(errorEnd)
                    \(warningIcon) \(warningMessage)
                    """
                )

                
            }
            .textSelection(.enabled)
        }
    }
    
    func inputPrompt(prompt: TerminalOutput.Prompt) -> some View {
        HStack(spacing: 3) {
            Text(prompt.directory)
                .foregroundStyle(.secondary)
                .lineLimit(1)

            Symbol("chevron.forward",
                   font: .system(.caption, weight: .regular),
                   gradient: .flat
            )
            .padding(.trailing, 5)
                
            Text(prompt.command)
                .fontWeight(.semibold)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 5)
        .padding(.bottom, 10)
    }
}


