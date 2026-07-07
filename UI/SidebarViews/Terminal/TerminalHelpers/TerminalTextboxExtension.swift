//
//  Textbox.swift
//  Terminal++
//
//  Created by Matt on 7/7/26.
//
import SwiftUI

extension TerminalTextbox {
    @ViewBuilder
    func displaySmallOverlay() -> some View {
        if toggleSmallOverlay {
            SmallOverlay(
                terminal: terminal,
                history: history,
                selectedTab: $selectedSmallTab
            )
            .createTransition(
                from: Edge.bottom,
                with: AnyTransition.opacity
            )
        }
    }
    
    // button that displays over the terminal input box
    func textboxToggleButton() -> some View {
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
        .shadow(radius: 3)
        .offset(x: -25)
        
    }
}
