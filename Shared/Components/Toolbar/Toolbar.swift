//
//  TerminalToolbarItem.swift
//  Terminal++
//
//  Created by Matt on 7/9/26.
//

import SwiftUI


struct Toolbar: ToolbarContent {
    let placement: ToolbarItemPlacement
    let symbol: String
    let action: () -> Void
    
    init(
        _ placement: ToolbarItemPlacement, 
        _ symbol: String, 
        action: @escaping () -> Void
    ) {
        self.placement = placement
        self.symbol = symbol
        self.action = action
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            
            AnimatedButton(.bouncy(duration: 0.5)) {
                action()
            }
            label: {
                Symbol(symbol)
            }
        }
    }
}

