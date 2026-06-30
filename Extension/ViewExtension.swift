//
//  ViewExtension.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI
extension View {
    func createTransition(from edge: Edge, with transition: AnyTransition) -> some View {
        return self
            .transition(
                .move(edge: edge)
                .combined(with: transition)
            )
            .shadow(radius: 5)
        
    }
    
    func glassRect(
        _ glassColor: Glass = .regular,
        radius: CGFloat = 10,
        padding: CGFloat = 0,
    ) -> some View {
        return self
            .glassEffect(
                glassColor,
                in:RoundedRectangle(cornerRadius: radius)
            )
            .padding(padding)
    }
    
    func bgRect(
        _ color: NSColor,
        radius: CGFloat = 10,
        padding: CGFloat = 0,
    ) -> some View {
        return self
        .background(
            Color(nsColor: color),
            in: .rect(cornerRadius: radius)
        )
        .padding(padding)
    }
    
    func neswPadding(
        _ north: CGFloat,
        _ east: CGFloat,
        _ south: CGFloat,
        _ west: CGFloat
    ) -> some View {
        self
            .padding(EdgeInsets(
                top: north,
                leading: west,
                bottom: south,
                trailing: east
            ))
    }
}


struct Symbol: View {
    let name: String
    let font: Font?
    let render: SymbolRenderingMode?
    let gradient: SymbolColorRenderingMode?
    
    init(
        name: String,
        font: Font? = .default,
        render: SymbolRenderingMode? = nil,
        gradient: SymbolColorRenderingMode? = .none
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
            .symbolColorRenderingMode(.gradient)
    }
}
















