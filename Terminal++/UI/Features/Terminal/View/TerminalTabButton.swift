//
//  TerminalTabButton.swift
//  Terminal++
//
//  Created by Matt on 7/10/26.
//
import SwiftUI

struct TerminalTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void


    var body: some View {
        AnimatedButton(.bouncy, action: { action() }, label: {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .lineLimit(1)
                .padding(.horizontal, 10)
                .frame(height: 30)
                .contentShape(RoundedRectangle(cornerRadius: 12))
                .background {
                    RoundedRectangle(cornerRadius: 12).fill(
                        isSelected ? ColorLib.selectedButton.color : Color.clear
                    )
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 12).stroke(
                        isSelected ? ColorLib.selectedButton.color : Color.clear
                    )
                }
        })
        .buttonStyle(.plain)
    }
}
