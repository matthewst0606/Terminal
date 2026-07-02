//
//  TerminalOverlayView.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//
import SwiftUI

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
