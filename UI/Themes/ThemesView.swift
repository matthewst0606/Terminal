//
//  ThemesView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//
import SwiftUI

struct ThemesView: View {
    @AppStorage("glassStyle") var selectedGlassStyle: GlassStyle = .regular
    @AppStorage("colorMode") var selectedColorMode: ColorMode = .system
    @AppStorage("fontDesign") var selectedFontDesign: FontPicker = .system

    var body: some View {
        HStack {
            List {
                ThemesPicker(title: "Glass", selection: $selectedGlassStyle)
                ThemesPicker(title: "Mode", selection: $selectedColorMode)
                ThemesPicker(title: "Font", selection: $selectedFontDesign)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .textSelection(.enabled)
            .neswPadding(5, 10, 5, 10)
        }
    }
}



