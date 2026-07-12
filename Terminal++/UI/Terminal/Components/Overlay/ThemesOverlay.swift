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
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Themes")
                .font(.title3.weight(.semibold))
                .padding(.horizontal, 18)
                .padding(.top, 16)

            List {
                ThemesPicker(title: "Glass", selection: $selectedGlassStyle)
                ThemesPicker(title: "Mode", selection: $selectedColorMode)
                ThemesPicker(title: "Font", selection: $selectedFontDesign)
            }
            .terminalList()
            .frame(
                minWidth: 250,
                minHeight: 200,
            )

            .bgRect(Color(nsColor: .textBackgroundColor).opacity(0.55), radius: 24)
            .padding(10)


        }
        .frame(
            maxWidth: 300,
            maxHeight: 300,
            alignment: .topTrailing
        )
        
        .glassRect(radius: 24)

    }
}
