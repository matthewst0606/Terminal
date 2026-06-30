//
//  TerminalView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//
import SwiftUI

struct TerminalView: View {
    @Binding var output: String
    @Binding var history: [String]
    var body: some View {
        HStack {
            ScrollView {
                Text(output)
                    .font(.system(
                        size: 14,
                        weight: .regular,
                        design: .monospaced
                    ))
                    .neswPadding(5, 10, 5, 10)
                
                Text(history.joined(separator: ", "))
                
            }
            .textSelection(.enabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassRect(radius: 0)

        
        DisplayTextbox(output: $output, history: $history)
    }
    
}


struct SmallDisplayOverlay: View {
    var body: some View {
        HStack {
            smallDisplayButton("apple.terminal.fill") { }
            Divider()
            smallDisplayButton("text.badge.plus") { }
            Divider()
            smallDisplayButton("slider.horizontal.3") { }
        }
        .padding()
        .frame(width: 250, height: 50, alignment: .leading)
        .glassEffect(in:RoundedRectangle(cornerRadius: 24))
        .offset(x: -10, y: -75)
    }
    
    private func smallDisplayButton(
        _ image: String,
        action: @escaping () -> Void
    ) -> some View {
        return ZStack {
            Button { action() }
            label: {
                Symbol(
                    name: image,
                    font: .system(size: 20),
                    render: .multicolor,
                    gradient: .gradient
                )
            }
        }

        .background(.clear)
        .buttonStyle(.plain)
    }
}


struct DisplayTextbox: View {
    @State private var input: String = ""

    @Binding var output: String
    @Binding var history: [String]

    @State private var toggleSmallOverlay: Bool = false

    
    var body: some View {
        HStack {
            Text(">>").neswPadding(10, 0, 10, 10)

            
            TextField("", text: $input)
                .onSubmit {
                    output += "\n<User> → \(input)\n"
                    output += "\(RustService.shared.execute(input))"
                    history.append("\(RustService.shared.history(input))")
                    input = ""
                }
                .textFieldStyle(.plain)
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .glassRect(radius: 24)
        .neswPadding(0, 15, 10, 10)

        .overlay(alignment: .trailing) {
            smallOverlayToggle()
        }
        
        
        
        .background(alignment: .bottomTrailing) {
            if toggleSmallOverlay {
                SmallDisplayOverlay()
                    .createTransition(
                        from: Edge.bottom,
                        with: AnyTransition.opacity
                    )
            }
        }
    }
    
    func smallOverlayToggle() -> some View {
        return ZStack {
            Button {
                withAnimation(.bouncy(duration: 0.2)) {
                    toggleSmallOverlay.toggle()
                }
            }
            label: {
                Symbol(
                    name: "arrow.up",
                    font: .title2,
                    render: .multicolor
                )
                .padding(5)
                .symbolEffect(
                    .bounce,
                    options: .nonRepeating,
                    isActive: toggleSmallOverlay,
                )
            }

            .buttonBorderShape(.circle)
        }
        .glassEffect(in:Circle())
        .offset(x: -25, y: -5)
    }
}

