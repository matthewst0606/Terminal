//
//  TextBoxView.swift
//  Terminal++
//
//  Created by Matt on 6/30/26.
//

import SwiftUI

struct TerminalTextbox: View {
    @State private var toggleSmallOverlay: Bool = false
    @State private var selectedSmallTab: SmallTabs = .none


    @ObservedObject var terminal: TerminalService
    
    var body: some View {
        HStack {
            TextField(
                "Enter a command",
                text: $terminal.input
            )
            .padding()
            .textFieldStyle(.plain)
            .onSubmit { terminal.submit() }
            .frame(maxWidth: .infinity, minHeight: 70)
            .glassRect(radius: 24)
            .bgRectBorder(radius: 24)
        }
        .padding()
        .overlay(alignment: .trailing) {
            textboxToggleButton()
        }
        .background(alignment: .bottomTrailing) {
            displaySmallOverlay()
        }
    }
    
    
    @ViewBuilder
    private func displaySmallOverlay() -> some View {
        if toggleSmallOverlay {

            SmallOverlay(terminal: terminal, selectedTab: $selectedSmallTab)
            .createTransition(
                from: Edge.bottom,
                with: AnyTransition.opacity
            )
        }
    }

    // button that displays over the terminal input box
    private func textboxToggleButton() -> some View {
        return VStack {
            AnimatedButton(.bouncy(duration: 0.2)) {
                toggleSmallOverlay.toggle()
            }
            label: {
                Symbol(
                    name: "ellipsis",
                    font: .title2,
                    render: .multicolor,
                    gradient: .gradient
                ).padding((8))
            }
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .offset(x: -25)
    }
}
