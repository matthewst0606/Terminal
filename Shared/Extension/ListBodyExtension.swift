//
//  TerminalListExtension.swift
//  Terminal++
//
//  Created by Matt on 7/9/26.
//

import SwiftUI

extension ListBody {
    enum DisplayStyle {
        case regular, overlay
    }
    
    @ViewBuilder
    func terminalListStyle(_ style: DisplayStyle) -> some View {
        switch style {
            
            
        case .regular:
            self.frame(
                minWidth: 450,
                maxWidth: .infinity,
                minHeight: 450,
                maxHeight: .infinity
            )
            .bgRect(Color(nsColor: .textBackgroundColor).opacity(0.55), radius: 12)
            .bgRectBorder(.primary, opacity: 0.1, radius: 12)
            .padding(.horizontal, 18)
            .padding(.bottom, 18)
            
            
            
        case .overlay:
            self.frame(
                minWidth: 100,
                maxWidth: 250,
                minHeight: 200,
                maxHeight: .infinity
            )
            .bgRect(Color(nsColor: .textBackgroundColor).opacity(0.5), radius: 10)
            .bgRectBorder(.primary, opacity: 0.1, radius: 10)
            .padding(5)

        }
    }
}
