//
//  ThemesPicker.swift
//  Terminal++
//
//  Created by Matt on 7/8/26.
//
import SwiftUI

protocol pickerOption: Hashable, CaseIterable {
    var label: String { get }
}

struct ThemesPicker<Option: pickerOption>: View {
    let title: String
    @Binding var selection: Option
    
    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(Array(Option.allCases), id: \.self) { option in
                Text(option.label)
                    .tag(option)
            }
        }
        .padding(.vertical, 10)
    }
}

enum IconColor: String, CaseIterable, pickerOption {
    case mono, multi
    
    var label: String {
        switch self {
        case .mono:  "monochrome"
        case .multi: "multicolor"
        }
    }
}

enum GlassStyle: String, CaseIterable, pickerOption {
    case regular, clear, none
    
    var label: String {
        switch self {
        case .regular: "Regular"
        case .clear:   "Clear"
        case .none:    "None"
        }
    }
}

enum ColorMode: String, CaseIterable, pickerOption {
    case system, light, dark
    
    var label: String {
        switch self {
        case .system: "System"
        case .light:  "Light"
        case .dark:   "Dark"
        }
    }
}

enum FontPicker: String, CaseIterable, pickerOption {
    case system, monospaced, rounded, serif
    var label: String {
        switch self {
        case .system:     "Default"
        case .monospaced: "Monospaced"
        case .rounded:    "Rounded"
        case .serif:      "Serif"
        }
    }
    
    var design: Font.Design {
        switch self {
        case .system:     .default
        case .monospaced: .monospaced
        case .rounded:    .rounded
        case .serif:      .serif
        }
    }
}
