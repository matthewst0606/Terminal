//
//  ContentView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI
struct ContentView: View {
    @State private var sidebarTab: SidebarTabs = .terminal
    private var workspace = TerminalWorkspace()
    
    var body: some View {
        TerminalView(workspace: workspace)
    }
}
