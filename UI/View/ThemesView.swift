//
//  ThemesView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//
import SwiftUI

struct ThemesView: View {
    var body: some View {
        HStack {
            ScrollView {
                Text("Glass")
                Text("Regular")
                Text("Custom")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .textSelection(.enabled)
            .neswPadding(5, 10, 5, 10)
        }
    }
}
