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
    let size: OverlayButtonSize
    let action: () -> Void

    @State private var isHovering = false

    init(
        _ item: OverlayButtonItem,
        _ isSelected: Bool,
        _ size: OverlayButtonSize,
        action: @escaping () -> Void
    ) {
        self.item = item
        self.isSelected = isSelected
        self.size = size
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            OverlayButtonLabel(
                item: item,
                isSelected: isSelected,
                size: size
            )
        }
        .shadow(radius: 2)
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
    let size: OverlayButtonSize

    var body: some View {
        HStack {
            Symbol(
                item.icon,
                font: .system(size: 14)
            )
            .frame(width: 24, height: 24)

            if let title = item.title {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .neswPadding(8, 8, 8, 0)
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: size.radius))
        .padding(size.padding)
        .bgRect(backgroundColor, radius: size.radius)
    }

    private var backgroundColor: Color {
        isSelected
            ? Color(nsColor: .systemBlue).opacity(0.22)
            : .clear
    }
}


struct OverlayButtonItem: Identifiable {
    let id = UUID()
    let title: String?
    let icon: String

    init(_ title: String? = nil, _ icon: String) {
        self.title = title
        self.icon = icon
    }
}

enum OverlayButtonSize {
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
