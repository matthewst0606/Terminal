//
//  TextBox.swift
//  Terminal++
//
//  Created by Matt on 7/7/26.
//
import SwiftUI

enum TextboxStyle {
    case plain, glass, backgroundBlur
}

struct Textbox: View {
    var placeholder: String
    @State var text: Binding<String>
    var action: () -> Void
    
    init(
        _ placeholder: String,
        text: Binding<String>,
        action: @escaping () -> Void
    ) {
        self.placeholder = placeholder
        self.text = text
        self.action = action
    }
    
    var body: some View {
        TextField(
            placeholder,
            text: text
        ).onSubmit {
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
        case .plain: self
            .frame(maxWidth: .infinity, minHeight: 70)


        case .glass: self
            .frame(maxWidth: .infinity, minHeight: 70)
            .background(.clear)
            .glassRect(radius: 24)
            .bgRectBorder(radius: 24, padding: 10)
            
        case .backgroundBlur: self
            .frame(maxWidth: .infinity, minHeight: 70)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .blur(radius: 24)
            )
        }
    }
}
