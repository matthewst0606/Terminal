//
//  TerminalView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//
import SwiftUI

struct TerminalView: View {
    @Binding var output: String
    @Binding var history: [String]
    var body: some View {
        HStack {
            ScrollView { terminalTextOutput() }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        }
        
        TerminalTextbox(
            output: $output,
            history: $history
        )
    }
    
    
    // =============
    // -- helpers --
    // =============
    private func terminalTextOutput() -> some View {
        return Text(output)
        .font(.system(
            size: 14,
            weight: .regular,
            design: .monospaced
        ))
        .neswPadding(5, 10, 5, 10)
        .textSelection(.enabled)
    }
}




struct TerminalOverlay: View {
    var body: some View {
        VStack {
            ScrollView {
                Text("things go here")
            }
            .frame(width: 100, height: 100, alignment: .center)
            .textSelection(.enabled)
            .glassRect(radius: 24)
        }
    }
}








