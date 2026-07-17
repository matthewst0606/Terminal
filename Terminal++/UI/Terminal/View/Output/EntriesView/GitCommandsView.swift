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
                
                Text(branch      ).fontWeight(.semibold)
                Text(branchStatus).foregroundStyle(.secondary)
            }

            
            ForEach(entries, id: \.path) { entry in
                HStack {
                    
                    Symbol(entry.status == "deleted" ?
                        "trash" : "square.and.pencil"
                    )
                    
                    
                    Text(entry.status.capitalized)
                        .foregroundStyle(entry.status == "deleted"
                            ? .red
                            : .orange
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
            
            
            added > 0
                ? Text("\(added) added.").fontWeight(.semibold)
                : Text("No files added.").foregroundStyle(.secondary)

            modified > 0
                ? Text("\(modified) modified.").fontWeight(.semibold)
                : Text("No files modified."   ).foregroundStyle(.secondary)
            
            deleted > 0
                ? Text("\(deleted) deleted.").fontWeight(.semibold)
                : Text("No files deleted."  ).foregroundStyle(.secondary)

        }
    }
}
