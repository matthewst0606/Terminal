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
                Picker("Glass", selection: $selectedGlassStyle) {
                    Text("Regular").tag(GlassStyle.regular)
                    Text("Clear").tag(GlassStyle.clear)
                    Text("None").tag(GlassStyle.none)
                }
                
                Picker("Mode", selection: $selectedColorMode) {
                    Text("System").tag(ColorMode.system)
                    Text("Light").tag(ColorMode.light)
                    Text("Dark").tag(ColorMode.dark)

                }
                Picker("Font", selection: $selectedFontDesign) {
                    Text("Default").tag(FontPicker.system)
                    Text("Monospaced").tag(FontPicker.monospaced)
                    Text("Rounded").tag(FontPicker.rounded)
                    Text("Serif").tag(FontPicker.serif)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .textSelection(.enabled)
            .neswPadding(5, 10, 5, 10)
        }
    }
}








