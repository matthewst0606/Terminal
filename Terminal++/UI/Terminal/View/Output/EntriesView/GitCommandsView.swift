//
//  GitCommandsView.swift
//  Terminal++
//
//  Created by Matt on 7/12/26.
//
import SwiftUI

struct GitCommandsView: View {
    let branch: String
    let branchStatus: String
    let entries: [GitStatusEntry]

    var body: some View {
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
                    
                    Symbol(entry.status == "deleted" ?
                        "trash" : "square.and.pencil"
                    )
                    
                    
                    Text(entry.status.capitalized)
                        .foregroundStyle(entry.status == "deleted" ?
                            .red : .orange
                        )
                        .frame(width: 80, alignment: .leading)

                    
                    Text(entry.path)
                }
            }
        }
    }
}

struct GitAddView: View {
    
    let added: Int
    let modified: Int
    let deleted: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Symbol("arrow.trianglehead.branch")
                Text("Git Add:")
            }
            .frame(alignment: .leading)
            
            if added > 0 {
                Text("\(added) added.")
                    .fontWeight(.semibold)
            }
            else {
                Text("No files added.")
                    .foregroundStyle(.secondary)
            }
            
            if modified > 0 {
                Text("\(modified) modified.")
                    .fontWeight(.semibold)
            }
            else {
                Text("No files modified.")
                    .foregroundStyle(.secondary)
            }
            
            if deleted > 0 {
                Text("\(deleted) deleted.")
                    .fontWeight(.semibold)
            }
            else {
                Text("No files deleted.")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview("Git add summary") {
    let summary = CommandOutputCustomizer.gitAddSummary(from: """
    A  NewFile.swift
    A  AnotherFile.swift
    M  Terminal.swift
    D  OldFile.swift
    """)

    return GitAddView(
        added: summary.added,
        modified: summary.modified,
        deleted: summary.deleted
    )
    .padding()
}
