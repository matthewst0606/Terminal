//
//  OverlayMenuItem.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//

import Foundation
import SwiftUI

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
    

    
    
    
    private var SmallButton: some View {
        formatSymbol(
            fontSize: 18,
            buttonRadius: 4,
            paddingSize: 2
        )
    }
    
    
    private var LargeButton: some View {
        HStack {
            formatSymbol(
                fontSize: 20,
                buttonRadius: 10,
                paddingSize: 4
            )
        }
    }
    
    
    
    private func formatSymbol(
        fontSize: CGFloat,
        buttonRadius: CGFloat,
        paddingSize: CGFloat,
    ) -> some View {
        
        return HStack {
            
            Symbol(
                name: item.image,
                font: .system(size: fontSize),
                render: .multicolor,
                gradient: .gradient
            )
            .frame(maxWidth: 25, maxHeight: 25)

            
            if item.title != nil {
                formatText()
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: buttonRadius))
        .padding(paddingSize)

        .bgRect(backgroundColor, radius: buttonRadius)
    }
    
    
    
    private func formatText() -> some View {
        return Text(item.title!)
            .font(.system(size: 14))
            .frame(maxWidth: .infinity, alignment: .leading)
            .neswPadding(10, 10, 10, 0)
    }

    private var backgroundColor: Color {
        switch true {
        case isSelected:  return Color.accentColor.opacity(0.5)
        default:          return Color.clear
            
        }
    }
}

enum SmallTabs {
    case none, terminal, keywords, history, themes, newTab
}

enum LargeTabs {
    case terminal, keywords, history, themes
}

enum DisplayButtonStyle {
    case large
    case small
}
