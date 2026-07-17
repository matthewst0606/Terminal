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
        case .regular: self
//            .frame(
//                maxWidth: .infinity,
//                maxHeight: .infinity
//            )
//            .backgroundRect(.secondary, radius: 12)
//            .padding(.horizontal, 18)
//            .padding(.bottom, 18)
            
        case .overlay: self
            .frame(
                minWidth: 100,
                maxWidth: 250,
                minHeight: 200,
                maxHeight: .infinity
            )
            .backgroundRect(.secondary, radius: 12)
            .padding(5)

        }
    }
}
