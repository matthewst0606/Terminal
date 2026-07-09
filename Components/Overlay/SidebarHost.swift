//
//  SidebarHost.swift
//  Terminal++
//
//  Created by Matt on 7/8/26.
//

import SwiftUI

struct SidebarHost<Content: View>: View {
    @Binding var selectedTab: SidebarTabs
    @State private var isSidebarVisible = false
    private let content: Content

    init(
        selectedTab: Binding<SidebarTabs>,
        @ViewBuilder content: () -> Content
    ) {
        self._selectedTab = selectedTab
        self.content = content()
    }

    var body: some View { content
        .toolbar {
            sidebarButton
        }
        .overlay(alignment: .topTrailing) {
            displaySidebar
        }
    }
}

private extension SidebarHost {
    var sidebarButton: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            AnimatedButton(.bouncy(duration: 0.3)) {
                isSidebarVisible.toggle()
            } label: {
                Symbol(
                    name: "sidebar.right",
                    render: .monochrome,
                    gradient: .gradient
                )
            }
        }
    }

    @ViewBuilder
    var displaySidebar: some View {
        if isSidebarVisible {
            Sidebar($selectedTab).modifier(
                OverlayTransition(.trailing)
            )
        }
    }
}

struct OverlayTransition: ViewModifier {
    var from: Edge
    
    init(_ from: Edge) {
        self.from = from
    }
    
    func body(content: Content) -> some View {
        content
        .transition(
            .move(edge: from)
            .combined(with: .opacity)
            .combined(with: .blurReplace)
            .animation(.bouncy)
        )
        .shadow(radius: 5)
    }
}
