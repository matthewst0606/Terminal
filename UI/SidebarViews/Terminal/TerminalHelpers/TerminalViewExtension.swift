//
//  TerminalViewExtension.swift
//  Terminal++
//
//  Created by Matt on 7/7/26.
//

import SwiftUI

extension TerminalSessionView {
    
    func terminalTextOutput() -> some View {
        Text(terminal.output)
            .font(.system(
                size: 14,
                weight: .regular,
                design: fontDesign
                
            ))
            .neswPadding(5, 10, 5, 10)
            .textSelection(.enabled)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var fontDesign: Font.Design {
        switch selectedFontDesign {
        case .system: return .default
        case .monospaced: return .monospaced
        case .rounded: return .rounded
        case .serif: return .serif
        }
    }
}
