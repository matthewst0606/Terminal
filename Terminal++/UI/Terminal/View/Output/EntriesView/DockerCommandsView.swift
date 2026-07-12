//
//  DockerCommandsView.swift
//  Terminal++
//
//  Created by Matt on 7/12/26.
//
import SwiftUI

struct DockerCommandsView: View {
    let entries: [DockerPsEntry]
    
    var body: some View {
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
