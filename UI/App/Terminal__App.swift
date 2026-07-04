//
//  Terminal__App.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

@main

struct Terminal__App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        WindowGroup(id: "content-window") {
            ContentView()
        }
    }
}

