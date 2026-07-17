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
        VStack(alignment: .leading, spacing: 10) {
            Text("Keywords")
                .toolbarContentTitle()
                .padding(.bottom, 10)

            Text("Built-in")
                .font(.callout.weight(.thin))
                .foregroundStyle(Color(nsColor: .secondaryLabelColor))
                .padding(.horizontal, 8)
            
            ListBody(
                items: keywords.builtin,
                style: .keyword,
                terminal: terminal,
                executesOnTap: true
            )
            .listBodyStyle()
            

            Text("Custom")
                .font(.callout.weight(.thin))
                .foregroundStyle(Color(nsColor: .secondaryLabelColor))
                .padding(.horizontal, 8)
            
            
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
        .frame(
            maxWidth: 450,
            maxHeight: .infinity,
            alignment: .topTrailing
        )
        .textSelection(.enabled)
        .scrollIndicators(.hidden)
        

        

    }
    
}

