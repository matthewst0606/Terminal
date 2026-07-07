//
//  KeywordsHelpers.swift
//  Terminal++
//
//  Created by Matt on 7/7/26.
//
import SwiftUI

extension KeywordsView {
    
    func formatTextField(_ title: String) -> some View {
        return Textbox(placeholder: title, text: $input) {
            keywords.addKeywordItem(
                lhs: input,
                rhs: input
            )
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .glassRect(radius: 24)
        .bgRectBorder(radius: 24)
        .neswPadding(0, 0, 40, 40)
    }
    
    func infoToggleButton() -> some View {
        return VStack {
            AnimatedButton(.bouncy(duration: 0.2)) {
                toggleSmallOverlay.toggle()
            }
            label: {
                Symbol(
                    name: "info",
                    font: .default,
                    render: .multicolor,
                    gradient: .gradient
                ).padding((8))
            }
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .neswPadding(0, 40, 40, 0)

    }
}

