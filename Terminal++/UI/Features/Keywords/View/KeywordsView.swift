//
//  KeywordsView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

struct KeywordsView: View {
    var keywords = KeywordsService()
    let terminal: Terminal
    
    var body: some View {
        TabView(content: {
            ListTab(
                title: "Default",
                symbol: "command.square.fill",
                items: keywords.builtin,
                style: .keyword,
                terminal: terminal,
                executesOnTap: true
            )
            ListTab(
                title: "Custom",
                symbol: "keyboard.badge.ellipsis.fill",
                items: keywords.custom,
                style: .keyword,
                terminal: terminal,
                executesOnTap: false
            )
            .overlay(
                alignment: .bottom,
                content: { KeywordTextbox(keywords: keywords) }
            )
            
        })
        .textSelection(.enabled)
    }
}


struct KeywordTextbox: View {
    @AppStorage("keywords") var input = ""
    @State var toggleSmallOverlay: Bool = false
    var keywords: KeywordsService

    var body: some View {
        Textbox("Enter keyword", for: $input, action: {
            keywords.addKeywordItem(input, input)
        })
        .textboxStyle(.glass)
        .overlay(alignment: .trailing, content: {
            TextBoxButtonView("info", for: $toggleSmallOverlay)
        })
        .padding(.horizontal, 18)
        .padding(.bottom, 18)
        .shadow(color: .black.opacity(0.12), radius: 14)
    }
}





struct KeywordOverlay: View {
    @AppStorage("keywords") var input = ""
    var keywords = KeywordsService()
    let terminal: Terminal

    var body: some View {
        VStack {
            ListBody(
                items: keywords.builtin,
                style: .keyword,
                terminal: terminal,
                executesOnTap: true
            )
            .terminalListStyle(.overlay)
            
            ListBody(
                items: keywords.custom,
                style: .keyword,
                terminal: terminal,
                executesOnTap: false
            )
            .terminalListStyle(.overlay)
        }
        .textSelection(.enabled)
    }
}
