//
//  TerminalView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//
import SwiftUI

struct TerminalView: View {
    @Binding var tabs: [TerminalTab]
    @Binding var selectedTerminalTab: TerminalTab.ID

    var body: some View {
        TabView(selection: $selectedTerminalTab) {
            ForEach(tabs) { tab in
                TerminalSessionView(
                    terminal: tab.terminal,
                    history: tab.history
                )
                .tabItem {
                    Text(tab.title)
                }
                .tag(tab.id)
            }
        }
        .toolbar {
            newTabBtn()
        }
        .kbShortcut("w", modifier: .command) {
            closeTab(selectedTerminalTab)
        }
    }
    
    

    private func newTabBtn() -> some ToolbarContent {
        return ToolbarItem(placement: .principal) {
            AnimatedButton(.bouncy(duration: 0.3)) {
                createNewTab()
            }
            label: {
                Symbol(
                    name: "plus",
                    render: .monochrome,
                    gradient: .gradient

                )
            }
        }
    }

    private func createNewTab() {
        let tab = TerminalTab(title: "Terminal \(tabs.count + 1)")
        tabs.append(tab)
        selectedTerminalTab = tab.id
    }

    private func closeTab(_ tab: TerminalTab.ID) {
        guard tabs.count > 1 else { return }
        let wasSelected = selectedTerminalTab == tab
        tabs.removeAll {
            $0.id == tab
        }

        if wasSelected {
            selectedTerminalTab = tabs.first!.id
        }
    }
}

struct TerminalSessionView: View {
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










