//
//  ContentView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI

struct ContentView: View {
    @State private var input: String = ""
    @State private var output: String = ""
    @State private var showOverlay: Bool = false
    @State private var showSmallOverlay: Bool = false

    var body: some View {
 
        VStack {
            HStack {
                ScrollView {
                    Text(output)
                        .font(
                            .system(size: 14, weight: .regular, design: .monospaced)
                        )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
            }
            
            displayTextbox()
                .shadow(radius: 10)
                .overlay(alignment: .trailing) {
                    ZStack {
                        Button {
                            withAnimation(.bouncy(duration: 0.2)) {
                                showSmallOverlay.toggle()
                            }
                        }
                        label: {
                            Image(systemName: "arrow.up")
                                .imageScale(.large)
                                .symbolRenderingMode(.multicolor)
                        }
                        .buttonBorderShape(.circle)
                    }
                    .glassEffect(in:Circle())
                    .offset(x: -25, y: -5)
                }
        }
        .overlay(alignment: .topTrailing) {
            if showOverlay {
                largeDisplayOverlay()
                    .transition(
                        .move(edge: .trailing)
                        .combined(with: .opacity)
                    )
                    .shadow(radius: 10)
            }
        }
        
        .background(alignment: .bottomTrailing) {
            if showSmallOverlay {
                smallDisplayOverlay()
                    .transition(
                        .move(edge: .bottom)
                        .combined(with: .opacity)
                    )
                    .shadow(radius: 5)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    withAnimation(.bouncy(duration: 0.3)) {
                        showOverlay.toggle()
                    }
                }
                label: {
                    Image(systemName: "sidebar.right")
                }
            }
        }
    }
    
    
    
    
    func largeDisplayOverlay() -> some View {
        return ZStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    Image(systemName: "terminal")
                    Text("Terminal++")
                }

                HStack {
                    Image(systemName: "text.badge.plus")
                    Text("Create Keywords")
                }
                
                HStack {
                    Image(systemName: "slider.horizontal.3")
                    Text("Themes")
                }
            }
            .padding()
        }
        
        .frame(width: 150, height: 300)
        .glassEffect(in:RoundedRectangle(cornerRadius: 24))
        .padding()
    }
    
    
    
    
    func smallDisplayOverlay() -> some View {
        return HStack(spacing: 5) {

            ZStack {
                Button {
                } label: {
                    Image(systemName: "apple.terminal.fill")
                        .imageScale(.large)
                        .symbolRenderingMode(.multicolor)
                }
                .buttonBorderShape(.circle)
            }
            .glassEffect(in:Circle())
            ZStack {
                Button {
                } label: {
                    Image(systemName: "text.badge.plus")
                        .imageScale(.large)
                        .symbolRenderingMode(.multicolor)
                }
                .buttonBorderShape(.circle)
            }
            .glassEffect(in:Circle())
            
            ZStack {
                Button {
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .imageScale(.large)
                        .symbolRenderingMode(.multicolor)
                }
                .buttonBorderShape(.circle)
            }
            .glassEffect(in:Circle())
        }
        .padding()
        
        

        .frame(width: 250, height: 50, alignment: .leading)
        .glassEffect(in:RoundedRectangle(cornerRadius: 15))
        .offset(x: -10, y: -75)
    }
    
    
    
    
    
    
    
    func displayTextbox() -> some View {
        return HStack {
            Text(">>")
                .padding(.vertical, 10)
                .padding(.leading, 10)
            
            TextField("", text: $input)
                .onSubmit {
                    output += "\n<User> → \(input)"
                    output += "\n\(RustService.shared.execute(input))"
                    input = ""
                }
                .textFieldStyle(.plain)

        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .glassEffect(in:RoundedRectangle(cornerRadius: 15))
        .padding(.bottom, 10)
        .padding(.horizontal, 10)
    }
}
