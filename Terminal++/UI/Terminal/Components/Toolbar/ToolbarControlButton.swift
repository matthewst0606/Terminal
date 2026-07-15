//
//  TerminalControlButton.swift
//  Terminal++
//
//  Created by Matt on 7/10/26.
//
import SwiftUI

struct ToolbarControlButton: View {
    let icon: String
    var isSelected = false
    let action: () -> Void

    var body: some View {
        AnimatedButton(.smooth) {
            action()
        }
        label: {
            Symbol(icon, render: .multicolor)
                .frame(width: 32, height: 32)
            
            .contentShape(RoundedRectangle(cornerRadius: 12))
            .backgroundRect(
                isSelected ? ColorLib.selectedButton.color : Color.clear,
                radius: 24,
            )
        }
        .buttonStyle(.plain)
    }
}
