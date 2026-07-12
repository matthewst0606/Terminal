//
//  Symbol.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//
import SwiftUI

struct Symbol: View {
    let name: String
    let font: Font?
    let render: SymbolRenderingMode?
    let gradient: SymbolColorRenderingMode?
    
    init(
        _ name: String,
        font: Font? = .system(size: 14, weight: .medium),
        render: SymbolRenderingMode? = .multicolor,
        gradient: SymbolColorRenderingMode? = .gradient
    ) {
        self.name = name
        self.font = font
        self.render = render
        self.gradient = gradient
    }
    
    var body: some View {
        Image(systemName: name)
            .font(font)
            .symbolRenderingMode(render)
            .symbolColorRenderingMode(gradient)
    }
}
