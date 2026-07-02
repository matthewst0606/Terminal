//
//  FormatKeywordItemExtension.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//

import SwiftUI

extension FormatKeywordItem {
    func listSeparator() -> some View {
        self
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(.white.opacity(0.06))
                    .frame(height: 1)
            }
    }
}
