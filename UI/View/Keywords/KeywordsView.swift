//
//  KeywordsView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

struct KeywordsView: View {
    @AppStorage("keywords") private var input = ""
    @StateObject private var keywords = KeywordsService()
    @State private var toggleSmallOverlay: Bool = false
    
    
    var body: some View {
        VStack {
            TabView {
                ListTab(
                    title: "Default",
                    symbol: "command.square.fill",
                    items: keywords.defaultKeywords,
                    style: .keyword
                )
                
                
                
                ListTab(
                    title: "Custom",
                    symbol: "keyboard.badge.ellipsis.fill",
                    items: keywords.customKeywords,
                    style: .keyword
                )
                .overlay(alignment: .bottom) {
                    HStack {
                        formatTextField("enter keyword")
                        infoToggleButton()
                    }
                }
            }

        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .top
        )
        .textSelection(.enabled)

    }
}




// =============
// -- helpers --
// =============
extension KeywordsView {
    
    private func formatTextField(_ title: String) -> some View {
        return TextField(title, text: $input)
            .onSubmit {
                keywords.addKeywordItem(
                    lhs: input,
                    rhs: input
                )
            }
            .textFieldStyle(.plain)
            .padding(10)
            .frame(maxWidth: .infinity)
            .glassRect(radius: 24)
            .bgRectBorder(radius: 24)
            .neswPadding(0, 0, 40, 40)


    }
    
    
    private func infoToggleButton() -> some View {
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



