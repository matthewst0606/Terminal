//
//  ThemesOverlayView.swift
//  Terminal++
//
//  Created by Matt on 7/2/26.
//

import SwiftUI

struct ThemesOverlay: View {
    var body: some View {
        VStack {
            
            List {

                Text("Glass")
                Text("Regular")
            }
            .terminalList()
            .frame(width: 120, height: 100, alignment: .center)
        }
        .glassRect(radius: 24)
        .neswPadding(0, 0, 10, 0)


    }
}
