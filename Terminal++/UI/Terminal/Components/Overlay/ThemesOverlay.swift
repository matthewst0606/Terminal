//
//  ThemesView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//
import SwiftUI

struct ThemesOverlay: View {
    @AppStorage("glassStyle") var selectedGlassStyle: GlassStyle = .regular
    @AppStorage("colorMode") var selectedColorMode: ColorMode = .system
    @AppStorage("fontDesign") var selectedFontDesign: FontPicker = .system
    @AppStorage("iconColor") var selectedIconColor: IconColor = .multi

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 14) {
           
            Text("Themes")
                .toolbarContentTitle()

            List {
                ThemesPicker(title: "Glass", selection: $selectedGlassStyle)
                ThemesPicker(title: "Mode", selection: $selectedColorMode)
                ThemesPicker(title: "Font", selection: $selectedFontDesign)
                ThemesPicker(title: "Icon Color", selection: $selectedIconColor)
            }
            .listBodyStyle()
        }
        .toolbarContentBackground()
    }
    
    

}
