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
    var selectedTabID: TerminalTab.ID
    var selectedTab: TerminalTab? {
        tabs.first {
            $0.id == selectedTabID
        } ?? tabs.first
    }

    
    init() {
        let firstTab = TerminalTab(title: "Shell 1")
        tabs = [firstTab]
        selectedTabID = firstTab.id
    }

    func createNewTab() {
        let tab = TerminalTab(title: "Shell \(tabs.count + 1)")
        tabs.append(tab)
        selectedTabID = tab.id
    }
    
    
    func closeTab(_ tab: TerminalTab.ID) {
        guard tabs.count > 1 else { return }

        let wasSelected = selectedTabID == tab
        tabs.removeAll { $0.id == tab }

        if wasSelected {
            selectedTabID = tabs.first!.id
        }
    }
}
