//
//  HistoryOverlayView.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//
import SwiftUI

struct HistoryOverlay: View {
    @ObservedObject var terminal: TerminalService
    @ObservedObject var history: HistoryService

    
    
    var body: some View {
        VStack {
            TerminalList(
                items: history.historyItem(),
                style: .history
            )

            .scrollContentBackground(.hidden)
            .frame(width: 100, height: 100, alignment: .center)
            .textSelection(.enabled)
            
        }
        .glassRect(radius: 24)

    }
}
