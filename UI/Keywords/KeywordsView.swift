//
//  KeywordsView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

struct KeywordsView: View {
    @AppStorage("keywords") var input = ""
    @State var toggleSmallOverlay: Bool = false
    var keywords = KeywordsService()
    
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
                        displayTextbox
                        infoToggleButton
                    }
                }
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .textSelection(.enabled)
    }
}

extension KeywordsView {
    var displayTextbox: some View {
        Textbox("enter keyword", text: $input) {
            keywords.addKeywordItem(input, input)
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .glassRect(radius: 24)
        .bgRectBorder(radius: 24)
        .neswPadding(0, 0, 40, 40)
    }
    
    var infoToggleButton: some View {
        VStack {
            AnimatedButton(.bouncy(duration: 0.2)) {
                toggleSmallOverlay.toggle()
            }
            label: {
                Symbol(
                    name: "info",
                    font: .default,
                )
                .padding((8))
            }
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .neswPadding(0, 40, 40, 0)

    }
}

