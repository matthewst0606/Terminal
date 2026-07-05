//
//  TerminalView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//
import SwiftUI

struct TerminalView: View {
    @ObservedObject var terminal: TerminalService
    @ObservedObject var history: HistoryService
    @AppStorage("fontDesign") var selectedFontDesign: FontPicker = .system

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    terminalTextOutput()
                        .padding(.bottom, 100)
                        .id("bottom")
                }
                .onChange(of: terminal.output) {
                    proxy.scrollTo("bottom", anchor: .bottom)
                }
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .overlay(alignment: .bottom) {
                
                
                TerminalTextbox(
                    terminal: terminal,
                    history: history
                )
            }
        }
            

    }
    
}


// =============
// -- helpers --
// =============
extension TerminalView {
    
    private func terminalTextOutput() -> some View {
        Text(terminal.output)
            .font(.system(
                size: 14,
                weight: .regular,
                design: fontDesign
                
            ))
            .neswPadding(5, 10, 5, 10)
            .textSelection(.enabled)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var fontDesign: Font.Design {
        switch selectedFontDesign {
        case .system: return .default
        case .monospaced: return .monospaced
        case .rounded: return .rounded
        case .serif: return .serif
        }
    }
}










