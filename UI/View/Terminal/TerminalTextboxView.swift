//
//  TextBoxView.swift
//  Terminal++
//
//  Created by Matt on 6/30/26.
//

import SwiftUI

struct TerminalTextbox: View {
    @State private var input: String = ""
    @State private var toggleSmallOverlay: Bool = false
    @Binding var output: String
    @Binding var history: [String]

    var body: some View {
        HStack {
            TextField(
                "Enter a command",
                text: $input
            )
            .padding()
            .textFieldStyle(.plain)
            .onSubmit { submit() }
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
            SmallDisplayOverlay(output: $output, history: $history)
                .createTransition(
                    from: Edge.bottom,
                    with: AnyTransition.opacity
                )
        }
    }
    
    // textbox submit action
    private func submit() {
        output += "\n<User> → \(input)\n"
        output += "\(RustService.shared.execute(input))"
        history.append("\(RustService.shared.history(input))")
        input = ""
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
