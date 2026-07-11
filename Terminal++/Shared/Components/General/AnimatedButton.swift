//
//  AnimatedButton.swift
//  Terminal++
//
//  Created by Matt on 7/1/26.
//
import SwiftUI

struct AnimatedButton<Label: View>: View {
    let animation: Animation
    let action: () -> Void
    let label: () -> Label
    
    init(
        _ animation: Animation = .bouncy(duration: 0.3),
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.animation = animation
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button {
            withAnimation(animation) { action() }
        } label: {
            label()
        }
    }
}
