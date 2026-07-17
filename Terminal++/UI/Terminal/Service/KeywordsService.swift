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
    var builtin: [ListElement]
    var custom: [ListElement]
    
    init(
        builtin: [ListElement] = KeywordsService.builtin(),
        custom: [ListElement] = KeywordsService.custom()
    ) {
        self.builtin = builtin
        self.custom = custom
    }
    
    func addKeywordItem(_ leadingText: String, _ trailingText: String) {
        custom.append(ListElement(
            leadingText: leadingText,
            trailingText: trailingText
        ))
    }
}

private extension KeywordsService {
    static func builtin() -> [ListElement] {[
        ListElement(leadingText: "help",               trailingText: "help"     ),
        ListElement(leadingText: "pwd | dir",          trailingText: "pwd"      ),
        ListElement(leadingText: "ls | list",          trailingText: "ls"       ),
        ListElement(leadingText: "clear",              trailingText: "clear"    ),
        ListElement(leadingText: "clearline",          trailingText: "clearline"),
        ListElement(leadingText: "sessions | session", trailingText: "sessions" ),
        ListElement(leadingText: "jobs | job",         trailingText: "jobs"     )
    ]}
    
    static func custom() -> [ListElement] {[
        ListElement(leadingText: "git add",    trailingText: "git add ."         ),
        ListElement(leadingText: "git commit", trailingText: "git commit -m \"\""),
        ListElement(leadingText: "git push",   trailingText: "git push"          ),
        ListElement(leadingText: "docker ps",  trailingText: "docker ps"         ),
    ]}
}


