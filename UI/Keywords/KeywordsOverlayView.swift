//
//  KeywordsOverlayView.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//

import SwiftUI

struct KeywordOverlay: View {
    @AppStorage("keywords") var input = ""
    var kw = KeywordsService()
    
    var body: some View {
        VStack {
            TerminalList(items: kw.defaultKeywords, style: .keyword)
                .terminalListStyle(.overlay)
            TerminalList(items: kw.customKeywords, style: .keyword)
                .terminalListStyle(.overlay)
        }
        .frame(maxWidth: 250, maxHeight: 500, alignment: .top)
        .textSelection(.enabled)
    }
}
