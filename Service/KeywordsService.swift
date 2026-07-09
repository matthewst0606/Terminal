//
//  KeywordsService.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//

import Observation
import Combine
import Foundation

@Observable
class KeywordsService {
    var defaultKeywords: [ListElement]
    var customKeywords: [ListElement]
    
    
    init(
        defaultKeywords: [ListElement] = KeywordsService.defaultListItems(),
        customKeywords: [ListElement] = KeywordsService.customListItems()
    ) {
        self.defaultKeywords = defaultKeywords
        self.customKeywords = customKeywords
    }
    
    func addKeywordItem(_ leadingText: String, _ trailingText: String) {
        customKeywords.append(ListElement(
            leadingText: leadingText,
            trailingText: trailingText
        ))
    }
}



extension KeywordsService {
    static func defaultListItems() -> [ListElement] {[
        ListElement(
            leadingText: "help",
            trailingText: "help"
        ),
        ListElement(
            leadingText: "pwd | dir",
            trailingText: "pwd"
        ),
        ListElement(
            leadingText: "ls | list",
            trailingText: "pwd"
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
            leadingText: "sessions | session",
            trailingText: "sessions"
        ),
        ListElement(
            leadingText: "jobs | job",
            trailingText: "jobs"
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
}



