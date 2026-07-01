//
//  KeywordsService.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//

import Foundation
import SwiftUI
internal import Combine

class KeywordsService: ObservableObject {
    @Published var defaultKeywords: [KeywordItem]
    @Published var customKeywords: [KeywordItem]
    
    init(
        defaultKeywords: [KeywordItem] = KeywordsService.defaultListItems(),
        customKeywords: [KeywordItem] = KeywordsService.customListItems()
    ) {
        self.defaultKeywords = defaultKeywords
        self.customKeywords = customKeywords
    }
    
    static func defaultListItems() -> [KeywordItem] {[
        KeywordItem(lhs: "help", rhs: "help"),
        KeywordItem(lhs: "cmd", rhs: "cmd"),
        KeywordItem(lhs: "cmd", rhs: "cmd"),
        KeywordItem(lhs: "cmd", rhs: "cmd"),
        KeywordItem(lhs: "cmd", rhs: "cmd")
    ]}
    
    
    static func customListItems() -> [KeywordItem] {[
        KeywordItem(lhs: "git add", rhs: "git add ."),
        KeywordItem(lhs: "git commit", rhs: "git commit -m \"\""),
        KeywordItem(lhs: "git push", rhs: "git push"),
    ]}
    
    func addKeywordItem(lhs: String, rhs: String) {
        customKeywords.append(KeywordItem(lhs: lhs, rhs: rhs))
    }
}

struct KeywordItem: Identifiable {
    var id = UUID()
    let lhs: String
    let rhs: String
}

struct FormatKeywordItem: View {
    let item: KeywordItem
    var body: some View {
        HStack {
            Text(item.lhs)
            Spacer()
            Text(item.rhs)
        }
    }
}
