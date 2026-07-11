//
//  TextBox.swift
//  Terminal++
//
//  Created by Matt on 7/7/26.
//
import SwiftUI

enum TextboxStyle {
    case plain, glass
}

struct Textbox: View {
    var placeholder: String
    let text: Binding<String>
    var action: () -> Void
    
    init(
        _ placeholder: String,
        for text: Binding<String>,
        action: @escaping () -> Void
    ) {
        self.placeholder = placeholder
        self.text = text
        self.action = action
    }
    
    var body: some View {
        TextField(placeholder, text: text).onSubmit {
            action()
        }
        .padding()
        .textFieldStyle(.plain)
    }
}

extension Textbox {
    @ViewBuilder
    func textboxStyle(_ style: TextboxStyle = .plain) -> some View {
        switch style {
            
        case .glass: self
            .applyFrame(.textbox)
            .background(.clear)
            .glassRect(radius: 24)
            
        default: self
            .applyFrame(.textbox)
        }
    }
}


struct TextBoxButtonView: View {
    var symbol: String
    @Binding var isVisible: Bool
    
    init(_ symbol: String, for isVisible: Binding<Bool>) {
        self.symbol = symbol
        self._isVisible = isVisible
    }
    
    var body: some View {
        VStack {
            AnimatedButton(.bouncy(duration: 0.3)) {
                isVisible.toggle()
            }
            label: {
                Symbol(symbol, font: .title2)
                    .frame(width: 32, height: 32)
                    
                    .contentShape(RoundedRectangle(cornerRadius: 12))
                    .glassRect(
                        radius: 24,
                    )
            }
        }
        .buttonStyle(.plain)
        
        .padding(.trailing, 25)

    }
}
