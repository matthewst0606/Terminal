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
            
            ListBody(
                items: keywords.builtin,
                style: .keyword,
                terminal: terminal,
                executesOnTap: true
            )
            .terminalList()
            .frame(minWidth: 250, minHeight: 200)
            .bgRect(Color(nsColor: .textBackgroundColor).opacity(0.75), radius: 24)

            ListBody(
                items: keywords.custom,
                style: .keyword,
                terminal: terminal,
                executesOnTap: false
            )
            .terminalList()
            .frame(minWidth: 250, minHeight: 200)
            .bgRect(Color(nsColor: .textBackgroundColor).opacity(0.75), radius: 24)
            
            
        }

        .padding(10)
        .glassRect(radius: 24)
        
        .frame(
            maxWidth: 300,
            maxHeight: 450,
            alignment: .topTrailing
        )
        .textSelection(.enabled)
        .scrollIndicators(.hidden)
        


    }
}
