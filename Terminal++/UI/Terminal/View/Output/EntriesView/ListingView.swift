//
//  ListingView.swift
//  Terminal++
//
//  Created by Matt on 7/12/26.
//
import SwiftUI

struct ListingCommandView: View {
    var terminal: Terminal
    let entries: [DirectoryEntry]
    
    
    
    var body: some View {
        let folders = entries
            .filter { $0.kind == "directory" }
            .sorted {$0.name.localizedStandardCompare($1.name) == .orderedAscending}
        let files = entries
            .filter { $0.kind == "file" }
            .sorted {$0.name.localizedStandardCompare($1.name) == .orderedAscending}

        
        
        LazyVStack(alignment: .leading, spacing: 4) {
            
            if !folders.isEmpty {
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
            }
            else {
                noneFound(
                    for: "folders",
                    icon: "questionmark.folder.fill"
                )
            }

            Divider().padding(.vertical, 6)
            
            
            
            if !files.isEmpty {
                ForEach(files, id: \.path) { entry in
                    listingRow(entry)
                }
            }
            else {
                noneFound(
                    for: "files",
                    icon: "questionmark.app"
                )
            }
            
            Divider()
                .padding(.vertical, 6)
                .padding(.bottom, 20)
        }
    }
    
    @ViewBuilder
    private func listingRow(_ entry: DirectoryEntry) -> some View {
        HStack(spacing: 10) {
            Symbol(entry.kind == "directory" ? "folder.fill" : "document")

            Text(entry.name)
                .fontWeight(.semibold)
                .frame(width: 220, alignment: .leading)

            Text(entry.path)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }
    
    private func noneFound(for item: String, icon: String) -> some View {
        HStack {
            Symbol(icon)
            Text("No \(item) in current directory.")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .italic()
                .lineLimit(1)
        }
    }
}
