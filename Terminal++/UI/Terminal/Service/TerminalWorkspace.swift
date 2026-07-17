//
//  TerminalWorkspace.swift
//  Terminal++
//
//  Created by Matt on 7/8/26.
//
import Observation

@Observable
final class TerminalWorkspace {
    var tabs: [TerminalTab]
    var id: TerminalTab.ID

    init() {
        let firstTab = TerminalTab(title: "Shell 1")
        tabs = [firstTab]
        id = firstTab.id
    }
    
    var selectedTab: TerminalTab? {
        tabs.first { $0.id == id } ?? tabs.first
    }

    func createNewTab() {
        let tab = TerminalTab(title: "Shell \(tabs.count + 1)")
        tabs.append(tab)
        id = tab.id
    }
    
    func closeTab(_ tab: TerminalTab.ID) {
        guard tabs.count > 1 else { return }
        tabs.removeAll { $0.id == tab }

        if id == tab {
            id = tabs.first!.id
        }
    }
}
