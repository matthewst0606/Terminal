//
//  TerminalSessionView.swift
//  Terminal++
//
//  Created by Matt on 7/8/26.
//
import SwiftUI

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

    var terminalTextOutput: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(terminal.output) { item in
                switch item.kind {
                case .text(let text):
                    Text("\(ANSIParser.attributedString(from: text))")                
                    
                case .listing(let entries):
                    ListingCommandView(
                        terminal: terminal,
                        entries: entries
                    )

                case .gitStatus(let branch, let branchStatus, let entries):
                    GitCommandsView(
                        branch: branch,
                        branchStatus: branchStatus,
                        entries: entries
                    )
                    
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
            maxWidth: .infinity,
            alignment: .topLeading
        )
        .lineSpacing(2)
        .textSelection(.enabled)
    }
    
    @ViewBuilder
    func errorFormat(
        _ command: String,
        _ message: String
    ) -> some View {
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




