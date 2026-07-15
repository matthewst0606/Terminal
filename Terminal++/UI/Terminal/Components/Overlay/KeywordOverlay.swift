//
//  KeywordsView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI



struct KeywordOverlay: View {
    @AppStorage("keywords") var input = ""
    var keywords = KeywordsService()
    let terminal: Terminal

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            Text("Keywords")
                .toolbarContentTitle()

            ListBody(
                items: keywords.builtin,
                style: .keyword,
                terminal: terminal,
                executesOnTap: true
            )
            .listBodyStyle()

            ListBody(
                items: keywords.custom,
                style: .keyword,
                terminal: terminal,
                executesOnTap: false
            )
            .listBodyStyle()
        }
        .padding(10)
        .glassRect(radius: 24)
        .frame(maxWidth: 300, maxHeight: 450, alignment: .topTrailing)
        .textSelection(.enabled)
        .scrollIndicators(.hidden)
    }
}
