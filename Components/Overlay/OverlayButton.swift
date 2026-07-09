//
//  OverlayButton.swift
//  Terminal++
//
//  Created by Matt on 7/7/26.
//

import SwiftUI

enum OverlayButtonStyle {
    case large
    case small
}

struct OverlayButton<Overlay: Hashable>: View {
    let item: OverlayItem<Overlay>
    let isSelected: Bool
    let style: OverlayButtonStyle
    let action: () -> Void
    @State private var isHovering = false
    
    var body: some View {
        Button { action() }
        label: {
            switch style {
            case .large: LargeButton
            case .small: SmallButton
            }
        }
        .shadow(radius: 2)

        .scaleEffect(isHovering ? 1.1 : 1.0)
        .opacity(isHovering || isSelected ? 1.0 : 0.75)
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.bouncy(duration: 0.2)) { isHovering = hovering }
        }
    }
}
