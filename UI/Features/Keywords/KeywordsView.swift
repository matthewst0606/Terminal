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
                    items: keywords.builtin,
                    style: .keyword
                )
                ListTab(
                    title: "Custom",
                    symbol: "keyboard.badge.ellipsis.fill",
                    items: keywords.custom,
                    style: .keyword
                )
                .overlay(alignment: .bottom) {
                    displayTextbox
                }
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .textSelection(.enabled)
    }

    
    
    
    var displayTextbox: some View {
        HStack {
            
            Textbox("enter keyword", text: $input) {
                keywords.addKeywordItem(input, input)
            }
            .textboxStyle(.glass)
            .overlay(alignment: .trailing) {
                infoToggleButton
            }
            .padding(40)
            .shadow(radius: 10)
            
        }
    }
    
    var infoToggleButton: some View {
        TextBoxButtonView("info", isVisible: $toggleSmallOverlay)
    }
}

