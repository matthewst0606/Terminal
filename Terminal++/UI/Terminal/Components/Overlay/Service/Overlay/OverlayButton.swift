//
//  OverlayButton.swift
//  Terminal++
//
//  Created by Matt on 7/9/26.
//
import SwiftUI

enum TerminalItem: Equatable {
    case none
    case terminal
    case keywords
    case history
    case themes
    case newTab
}

struct OverlayButtonItem: Identifiable {
    let id = UUID()
    let title: String?
    let icon: String
}

struct OverlayButton: View {
    let icon: String
    let title: String?
    let isSelected: Bool
    let action: () -> Void

    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack {
                Symbol(
                    icon,
                    font: .system(size: 18, weight: .semibold)
                )

                if let title {
                    Text(title)
                        .font(.system(size: 12, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .neswPadding(8, 8, 8, 0)
                }
            }
            .padding(title == nil ? 4 : 6)
            .background(
                isSelected ? ColorLib.selectedButton.color : .clear,
                in: RoundedRectangle(cornerRadius: title == nil ? 6 : 8)
            )
        }
        
        .scaleEffect(isHovering ? 1.03 : 1.0)
        .opacity(isHovering || isSelected ? 1.0 : 0.82)
        .buttonStyle(.plain)
        .animation(.snappy(duration: 0.16), value: isHovering)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}
