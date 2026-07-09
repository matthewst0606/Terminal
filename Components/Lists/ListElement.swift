//
//  ListElement.swift
//  Terminal++
//
//  Created by Matt on 7/3/26.
//
import SwiftUI

struct ListElement: Identifiable {
    var id = UUID()
    var leadingText: String? = nil
    var trailingText: String? = nil
    var leadingSymbol: String? = nil
    var trailingSymbol: String? = nil
}
