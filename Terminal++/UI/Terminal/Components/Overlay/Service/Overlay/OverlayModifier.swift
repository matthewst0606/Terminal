//
//  Overlay.swift
//  Terminal++
//
//  Created by Matt on 7/9/26.
//
import SwiftUI

struct OverlayModifier: ViewModifier {
    @State var toggleSmallOverlay: Bool = false
    @State var selectedSmallTab: TerminalItem = .none
    @Bindable var terminal: Terminal
    var history: TerminalHistory
    
    func body(content: Content) -> some View {
        content
        .background(alignment: .bottomTrailing, content: {
            displaySmallOverlay
        })
    }
    

    @ViewBuilder
    var displaySmallOverlay: some View {
        if toggleSmallOverlay {
            OverlayView(
                selectedTab: $selectedSmallTab,
                terminal: terminal,
                history: history
            )
            .modifier(OverlayTransition(.bottom))
        }
    }
}




struct OverlayTransition: ViewModifier {
    var from: Edge
    init(_ from: Edge) {
        self.from = from
    }
    
    func body(content: Content) -> some View {
        content
        .transition(
//            .move(edge: from)

            
            .opacity
            .combined(with: .blurReplace())
            .animation(.bouncy(duration: 0.3))
        )
        
        .shadow(radius: 5)
    }
}
