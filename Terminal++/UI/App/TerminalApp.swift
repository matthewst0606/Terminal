//
//  Terminal__App.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

@main
struct TerminalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        
        WindowGroup(id: "content-window") {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}
