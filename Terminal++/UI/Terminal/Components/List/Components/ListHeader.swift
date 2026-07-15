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
                Text(title)
                    .toolbarContentTitle()
                
                
                Symbol(
                    symbol,
                    font: .system(size: 18),
                    render: .hierarchical
                )
                .foregroundStyle(.secondary)
                Spacer()
            }
            
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
}
