//
//  OverlayMenuItem.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//

import Foundation
import SwiftUI

enum DisplayButtonStyle {
    case large
    case small
}

struct OverlayMenuItem<Overlay: Hashable>: Identifiable {
    let id = UUID()
    let title: String?
    let image: String
    let tab: Overlay

    init(title: String? = nil, image: String, tab: Overlay) {
        self.title = title
        self.image = image
        self.tab = tab
    }
}

struct DisplayButton<Overlay: Hashable>: View {
    let item: OverlayMenuItem<Overlay>
    let isSelected: Bool
    let style: DisplayButtonStyle
    let action: () -> Void
    @State private var isHovering = false
    
    var body: some View {
        Button {
            action()
        }
        label: {
            switch style {
            case .large: LargeButton
            case .small: SmallButton
            }
        }
        .scaleEffect(isHovering ? 1.1 : 1.0)
        .opacity(isHovering || isSelected ? 1.0 : 0.75)
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.bouncy(duration: 0.2)) { isHovering = hovering }
        }
    }
}

