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
                    
                    let folders = entries
                        .filter { $0.kind == "directory" }
                        .sorted {
                            $0.name.localizedStandardCompare($1.name) == .orderedAscending
                        }

                    let files = entries
                        .filter { $0.kind == "file" }
                        .sorted {
                            $0.name.localizedStandardCompare($1.name) == .orderedAscending
                        }

                    LazyVStack(alignment: .leading, spacing: 4) {
                        ForEach(folders, id: \.path) { entry in
                            Button {
                                terminal.submitNoPrompt("cd \(entry.path)")
                                terminal.submitNoPrompt("ls")
                            } label: {
                                listingRow(entry)
                            }
                            .buttonStyle(.plain)
                            .frame(width: 200, alignment: .leading)
                        }

                        Divider().padding(.vertical, 6)
                        
                        ForEach(files, id: \.path) { entry in
                            listingRow(entry)
                        }
                        
                        Divider().padding(.vertical, 6)
                    }
                    

                case .gitStatus(let branch, let branchStatus, let entries):
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Symbol("arrow.trianglehead.branch")
                            Text(branch)
                                .fontWeight(.semibold)
                            Text(branchStatus)
                                .foregroundStyle(.secondary)
                        }

                        
                        ForEach(entries, id: \.path) { entry in
                            HStack {
                                Symbol(entry.status == "deleted" ? "trash" : "square.and.pencil")
                                Text(entry.status.capitalized)
                                    .foregroundStyle(
                                        entry.status == "deleted" ? .red : .orange
                                    )
                                    .frame(width: 80, alignment: .leading)

                                Text(entry.path)
                            }
                        }
                    }
                    
                case .dockePs(let entries):
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 12) {
                            dockerColumnHeader("square.stack.3d.up", "CONTAINER", width: 180)
                            dockerColumnHeader("photo", "IMAGE", width: 180)
                            dockerColumnHeader("wifi", "PORTS", width: 160)
                            dockerColumnHeader("checkmark", "STATUS", width: 180)
                        }

                        ForEach(entries, id: \.container_id) { entry in
                            HStack(spacing: 12) {
                                dockerColumnValue(entry.container, width: 180)
                                dockerColumnValue(entry.image, width: 180)
                                dockerColumnValue(entry.ports, width: 160)
                                dockerColumnValue(entry.status, width: 180)
                            }
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
    
    @ViewBuilder
    func listingRow(_ entry: DirectoryEntry) -> some View {
        HStack(spacing: 10) {
            Symbol(entry.kind == "directory" ? "folder" : "document")

            Text(entry.name)
                .fontWeight(.semibold)
                .frame(width: 220, alignment: .leading)

            Text(entry.path)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }

    @ViewBuilder
    func dockerColumnHeader(_ symbol: String, _ title: String, width: CGFloat) -> some View {
        HStack(spacing: 8) {
            Symbol(symbol).frame(width: 20)
            Text(title)
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .frame(width: width, alignment: .leading)
    }

    @ViewBuilder
    func dockerColumnValue(_ value: String, width: CGFloat) -> some View {
        Text(value)
            .padding(.leading, 28)
            .frame(width: width, alignment: .leading)
    }
}
