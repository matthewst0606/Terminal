//
//  TextBox.swift
//  Terminal++
//
//  Created by Matt on 7/7/26.
//
import SwiftUI

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
        .frame(maxWidth: .infinity, minHeight: 70, maxHeight: 70)
        .background(.clear)
        .glassRect(radius: 24)
    }
}
