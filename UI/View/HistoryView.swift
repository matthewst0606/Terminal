//
//  HistoryView.swift
//  Terminal++
//
//  Created by Matt on 6/30/26.
//

import SwiftUI

struct HistoryView: View {
    @Binding var history: [String]
    var body: some View {
        HStack {
            ScrollView {
                Text(history.joined(separator: ", "))

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .textSelection(.enabled)
            .neswPadding(5, 10, 5, 10)
        }
    }
}
