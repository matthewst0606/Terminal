//
//  ThemesHelpers.swift
//  Terminal++
//
//  Created by Matt on 7/7/26.
//
import SwiftUI

enum GlassStyle: String, CaseIterable {
    case regular, clear, none
}


enum ColorMode: String, CaseIterable {
    case system, light, dark
}

enum FontPicker: String, CaseIterable {
    case system, monospaced, rounded, serif
}


extension ThemesView {
    private var switchGlassStyle: String {
        switch selectedGlassStyle {
        case .regular: "Regular"
        case .clear:   "Clear"
        case .none:    "None"
        }
    }
    
    private var switchColorMode: String {
        switch selectedColorMode {
        case .system: "System"
        case .light:  "Light"
        case .dark:   "Dark"

        }
    }
    
    private var switchFontDesign: Font.Design {
        switch selectedFontDesign {
        case .system: .default
        case .monospaced: .monospaced
        case .rounded: .rounded
        case .serif: .serif
        }
    }
}
