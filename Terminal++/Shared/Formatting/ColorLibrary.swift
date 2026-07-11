//
//  ColorLibrary.swift
//  Terminal++
//
//  Created by Matt on 7/10/26.
//

import SwiftUI

enum ColorLib {
    // Text
    case primaryText
    case secondaryText
    case tertiaryText

    // Surfaces and controls
    case panel
    case panelStrong
    case separator
    case accent
    case jobsList
    case backgroundJobsRow
    case suggestionText
    case textBackground
    case appBG
    case selectedButton

    var color: Color {
        switch self {
        case .primaryText:
            .primary

        case .secondaryText:
            .secondary

        case .tertiaryText:
            Color(nsColor: .tertiaryLabelColor)

        case .panel:
            Color(nsColor: .textBackgroundColor).opacity(0.5)

        case .panelStrong:
            Color(nsColor: .textBackgroundColor).opacity(0.75)

        case .separator:
            .primary.opacity(0.06)

        case .accent:
            Color.accentColor

        case .jobsList:
            ColorLib.panel.color
            
        case .backgroundJobsRow:
            ColorLib.secondaryText.color
            
        case .suggestionText:
            ColorLib.secondaryText.color.opacity(0.5)
            
        case .textBackground:
            ColorLib.panel.color
            
        case .appBG:
            Color(nsColor: .windowBackgroundColor)
            
        case .selectedButton:
            ColorLib.accent.color.opacity(0.22)
        }
    }

    static var appBackground: Color { ColorLib.appBG.color }
    static var panelBackground: Color { ColorLib.panel.color }
}
   
