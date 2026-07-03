//
//  StackExtension.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//
import SwiftUI

extension VStack {
    func VStackFormat() -> some View {
        self
            .frame(maxWidth: .infinity ,alignment: .leading)

            .bgRectBorder(radius: 24, padding: 10)
            .background(Color(NSColor.tertiarySystemFill))

            .neswPadding(5, 10, 10, 10)
    }
}
