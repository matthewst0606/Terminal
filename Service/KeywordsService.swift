//
//  KeywordsService.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//

import Foundation
import SwiftUI
import Combine

class KeywordsService: ObservableObject {
    @Published var defaultKeywords: [ListElement]
    @Published var customKeywords: [ListElement]
    
    init(
        defaultKeywords: [ListElement] = KeywordsService.defaultListItems(),
        customKeywords: [ListElement] = KeywordsService.customListItems()
    ) {
        self.defaultKeywords = defaultKeywords
        self.customKeywords = customKeywords
    }
    
    static func defaultListItems() -> [ListElement] {[
        ListElement(
            leadingText: "help",
            trailingText: "help"
        ),
        ListElement(
            leadingText: "clear",
            trailingText: "clear"
        ),
        ListElement(
            leadingText: "clearline",
            trailingText: "clearline"
        ),
        ListElement(
            leadingText: "cmd",
            trailingText: "cmd"
        ),
        ListElement(
            leadingText: "cmd",
            trailingText: "cmd"
        )
    ]}
    
    static func customListItems() -> [ListElement] {[
        ListElement(
            leadingText: "git add",
            trailingText: "git add ."
        ),
        ListElement(
            leadingText: "git commit",
            trailingText: "git commit -m \"\""
        ),
        ListElement(
            leadingText: "git push",
            trailingText: "git push"
        ),
    ]}
    
    
    func addKeywordItem(lhs: String, rhs: String) {
        customKeywords.append(ListElement(
            leadingText: lhs,
            trailingText: rhs
        ))
    }
}

