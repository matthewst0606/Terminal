//
//  HistoryOverlayView.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//
import SwiftUI

struct HistoryOverlay: View {
    @ObservedObject var terminal: TerminalService

    
    
    var body: some View {
        VStack {
            ScrollView {
                Text(terminal.history.joined(separator: ", "))
                
            }
            .scrollContentBackground(.hidden)
            .frame(width: 100, height: 100, alignment: .center)
            .textSelection(.enabled)
            
        }
        .glassRect(radius: 24)

    }
}
