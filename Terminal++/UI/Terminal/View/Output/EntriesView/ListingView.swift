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
    
    
    @State var isHovering: Bool = false
    @State private var hoveredFolderPath: String?
    
    let folderColumns = [
        GridItem(.adaptive(minimum: 90, maximum: 120), spacing: 12)
    ]

    // displays a custom view when "ls" is typed in the terminal
    // entries are sorted alphabetically, files and folders are
    //separated by dividers
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 4) {
            
            displayFolders

            Divider()
                .padding(.vertical, 6)
            
            displayFiles
            
            Divider()
                .padding(.vertical, 6)
                .padding(.bottom, 20)
        }
    }
}

extension ListingCommandView {
    
    @ViewBuilder
    var displayFolders: some View {
        
        let folders = entries
            .filter { $0.kind == "directory" }
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        
        if !folders.isEmpty {
            LazyVGrid(columns: folderColumns, alignment: .leading, spacing: 12) {
                
                ForEach(folders, id: \.path) { entry in
                    
                    let isHovering = hoveredFolderPath == entry.path

                    VStack(spacing: 4) {
                        Symbol(
                            isHovering ? "folder.fill" : "folder",
                            font: .system(size:32)
                        )

                        Text(entry.name)
                            .font(.system(size: 12, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .textSelection(.disabled)
                    .pointerStyle(.link)
                    
                    .padding(5)
                    .contentShape(.rect(cornerRadius: 24))
                    .background{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isHovering ? Color(nsColor: .tertiarySystemFill) : .clear)
                    }
                    
                    .scaleEffect(isHovering ? 1.1 : 1)
                    .animation(.smooth(duration: 0.2), value: isHovering)

                    .onTapGesture {
                        if terminal.submitNoPrompt("cd \(entry.path)") == true {
                            terminal.submitNoPrompt("clear")
                            terminal.submitNoPrompt("ls")

                        }
                    }

                    .onHover {
                        hoveredFolderPath = $0 ? entry.path : nil
                    }
                }
            }
        }
        else {
            noneFound(
                for: "folders",
                icon: "questionmark.folder.fill"
            )
        }
    }
    
    
    @ViewBuilder
    var displayFiles: some View {
        let files = entries
            .filter { $0.kind == "file" }
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        
        if !files.isEmpty {
            
            LazyVGrid(
                columns: folderColumns,
                alignment: .leading,
                spacing: 12
            ) {
                ForEach(files, id: \.path) { entry in
                    
                    let fileExtension = URL(fileURLWithPath: entry.name)
                        .pathExtension
                        .lowercased()
                    
                    let icon = ["jpg", "jpeg", "png", "webp"].contains(fileExtension)
                    ? "photo"
                    : "document"
                    
                    VStack(spacing: 4) {
                        Symbol(icon, font: .system(size: 24))
                        
                        
                        Text(entry.name)
                            .font(.system(size: 12, weight: .semibold))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .onTapGesture {
                        terminal.submitNoPrompt("open \"\(entry.path)\"")

                    }
                }
            }
        }
        else {
            noneFound(
                for: "files",
                icon: "questionmark.app"
            )
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
