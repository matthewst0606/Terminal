//
//  KeywordsOverlayView.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//

import SwiftUI

struct KeywordOverlay: View {
    @AppStorage("keywords") var input = ""
    @StateObject var keywords = KeywordsService()
//    @State var toggleSmallOverlay: Bool = false
    
    var body: some View {
        VStack {
                TerminalList(
                    items: keywords.defaultKeywords,
                    style: .keyword
                )
                .terminalListStyle(style: .overlay)

                TerminalList(
                    items: keywords.customKeywords,
                    style: .keyword
                )
                .terminalListStyle(style: .overlay)


            
            
        }
        .frame(maxWidth: 250,
               maxHeight: 500,
               alignment: .top
        )
        .textSelection(.enabled)
    }
}
