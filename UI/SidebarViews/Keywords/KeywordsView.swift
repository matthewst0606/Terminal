//
//  KeywordsView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

struct KeywordsView: View {
    @AppStorage("keywords") var input = ""
    @StateObject var keywords = KeywordsService()
    @State var toggleSmallOverlay: Bool = false
    
    
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


