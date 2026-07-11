//
//  OverlayButton.swift
//  Terminal++
//
//  Created by Matt on 7/9/26.
//
import SwiftUI

struct OverlayButton: View {
    let item: OverlayButtonItem
    let isSelected: Bool
    let action: () -> Void

    @State private var isHovering = false

    init(
        _ item: OverlayButtonItem,
        _ isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.item = item
        self.isSelected = isSelected
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            OverlayButtonLabel(
                item: item,
                isSelected: isSelected
            )
        }
        
        .scaleEffect(isHovering ? 1.03 : 1.0)
        .opacity(isHovering || isSelected ? 1.0 : 0.82)
        .buttonStyle(.plain)
        .animation(.snappy(duration: 0.16), value: isHovering)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

struct OverlayButtonLabel: View {
    let item: OverlayButtonItem
    let isSelected: Bool

    var body: some View {
        HStack {
            
            Symbol(
                item.icon,
                font: .system(size: 18, weight: .semibold)
            )


            if let title = item.title {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .neswPadding(8, 8, 8, 0)
                    
            }
        }
        .buttonSize(isSelected, buttonSize(for: item))
    }
    
    

    private func buttonSize(for item: OverlayButtonItem) -> OverlayButtonSize {
        item.title == nil ? .small : .large
    }

}


struct OverlayButtonItem: Identifiable {
    let id = UUID()
    let title: String?
    let icon: String
}

private enum OverlayButtonSize {
    case large, small

    var radius: CGFloat {
        switch self {
        case .large: 8
        case .small: 6
        }
    }

    var padding: CGFloat {
        switch self {
        case .large: 6
        case .small: 4
        }
    }
}

private extension View {
    func buttonSize(_ isSelected: Bool, _ size: OverlayButtonSize) -> some View {
        self
            .contentShape(RoundedRectangle(cornerRadius: size.radius))
            .padding(size.padding)
            .bgRect(
                isSelected ? ColorLib.selectedButton.color : .clear,
                radius: size.radius
            )
    }
}
