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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .bgRect(Color(nsColor: .textBackgroundColor).opacity(0.55), radius: 12)
            .bgRectBorder(.primary, opacity: 0.1, radius: 12)
            .padding(.horizontal, 18)
            .padding(.bottom, 18)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .textSelection(.enabled)
        .background(Color(nsColor: .windowBackgroundColor).ignoresSafeArea())
    }
}






struct ThemesOverlay: View {
    var body: some View {
        VStack {
            List {
                Text("Glass")
                Text("Regular")
            }
            .terminalList()
            
            .frame(
                width: 120,
                height: 100,
                alignment: .center
            )
        }
        .glassRect(radius: 24)
        .neswPadding(0, 0, 10, 0)

    }
}
