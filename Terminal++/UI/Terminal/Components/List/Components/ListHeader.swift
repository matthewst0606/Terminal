//
//  ListHeader.swift
//  Terminal++
//
//  Created by Matt on 7/12/26.
//
import SwiftUI
struct ListHeader: View {
    let title: String
    let symbol: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                titleContent
                symbolContent
                Spacer()
            }
            .padding(.horizontal, 18)

            
            HStack {
                Text("alias")
                Spacer()
                Text("command")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .padding(.horizontal, 32)
        }
    }
    
    private var titleContent: some View {
        Text(title)
            .font(.title3.weight(.semibold))
    }
    
    private var symbolContent: some View {
        Symbol(symbol, font: .system(size: 18), render: .hierarchical)
            .foregroundStyle(.secondary)
    }
}
