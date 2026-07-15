//
//  ColorLibrary.swift
//  Terminal++
//
//  Created by Matt on 7/10/26.
//

import SwiftUI

enum ColorLib: ShapeStyle {
    // Text
    case primaryText
    case secondaryText
    case tertiaryText

    // Surfaces and controls
    case panel
    case panelStrong
    case separator
    case accent
    case listRow
    case suggestionText
    case textBackground
    case appBG
    case selectedButton
    case overlayList
    

    var color: Color {
        switch self {
        case .primaryText:
            .primary

        case .secondaryText, .listRow, .suggestionText:
            .secondary

        case .tertiaryText:
            Color(nsColor: .tertiaryLabelColor)

        case .panel, .textBackground:
            Color(nsColor: .textBackgroundColor).opacity(0.5)

        case .panelStrong:
            Color(nsColor: .textBackgroundColor).opacity(0.75)

        case .separator:
            .primary.opacity(0.06)

        case .accent:
            Color.accentColor
            
        case .overlayList:
            Color(nsColor: .textBackgroundColor).opacity(0.55)


        case .appBG:
            Color(nsColor: .windowBackgroundColor)
            
        case .selectedButton:
            ColorLib.accent.color.opacity(0.22)
        }
    }

    static var appBackground: Color { ColorLib.appBG.color }
    static var panelBackground: Color { ColorLib.panel.color }
    
    func resolve(in environment: EnvironmentValues) -> Color.Resolved {
        color.resolve(in: environment)
    }
}
