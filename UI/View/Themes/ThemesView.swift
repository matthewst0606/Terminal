//
//  ThemesView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//
import SwiftUI

enum GlassStyle {
    case regular, clear, none
}

struct ThemesView: View {
    @State var selectedGlass: GlassStyle = .regular
    
    var body: some View {
        HStack {
            List {
                Picker("Glass", selection: $selectedGlass) {
                    Text("Regular").tag(GlassStyle.regular)
                    Text("Clear").tag(GlassStyle.clear)
                    Text("None").tag(GlassStyle.none)
                }
                Picker("Mode", selection: $selectedGlass) {
                    Text("System").tag(GlassStyle.regular)
                    Text("Dark").tag(GlassStyle.clear)
                    Text("Light").tag(GlassStyle.none)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .textSelection(.enabled)
            .neswPadding(5, 10, 5, 10)

        }
    }
}



extension ThemesView {
    private var glassSwitch: String {
        switch selectedGlass {
        case .regular:"Regular"
        case .clear: "Clear"
        case .none: "None"
        }
    }
}






