//
//  TerminalTextbox.swift
//  Terminal++
//
//  Created by Matt on 6/30/26.
//
import SwiftUI

struct TerminalTextbox: View {
    @Bindable var terminal: Terminal
    var history: TerminalHistory
    var prediction: PredictionService

    var body: some View {
        Textbox("Enter a command", text: $terminal.input) {
            terminal.submit()
            history.resetIndex()
        }
        .textboxStyle(.glass)
        .overlay(alignment: .leading) {
            PredictionTextView(
                terminal: terminal,
                prediction: prediction
            )
        }
        .padding(8)
        .shadow(radius: 10)
        
        .modifier (
        SmallOverlayView(
            terminal: terminal,
            history: history
        ))
        .modifier(
        TerminalKeyboardShortcuts(
            getPrevHistory: getPrevHistory,
            getNextHistory: getNextHistory
        ))
    }
}

// terminal keyboard shortcuts
private extension TerminalTextbox {
    func getPrevHistory() {
        guard let prev = history.previousCommand() else { return }
        DispatchQueue.main.async {
            self.terminal.input = prev
        }
    }
    func getNextHistory() {
        guard let next = history.nextCommand() else { return }
        DispatchQueue.main.async {
            self.terminal.input = next
        }
    }
}

// displays the text prediction inside of the textbox
struct PredictionTextView: View {
    @Bindable var terminal: Terminal
    var prediction: PredictionService
    
    var body: some View {
        if let suffix = predictionSuffix {
            HStack {
                Text(terminal.input).opacity(0)
                Text(suffix).foregroundStyle(
                    .secondary.opacity(0.5)
                )
            }
            .padding(.leading, 8)
            .allowsHitTesting(false)
        }
    }
    
    private var predictionSuffix: String? {
        guard let
            suggestions = prediction.showPredictiveText(),
            suggestions.hasPrefix(terminal.input),
            suggestions != terminal.input
        else {
            return nil
        }
        
        return String(suggestions.dropFirst(terminal.input.count))
    }
}

// terminal keyboard shortcuts
struct TerminalKeyboardShortcuts: ViewModifier {
    let getPrevHistory: () -> Void
    let getNextHistory: () -> Void

    func body(content: Content) -> some View { content
        .kbShortcut(
            .upArrow,
            action: getPrevHistory
        )
        .kbShortcut(
            .downArrow,
            action: getNextHistory
        )
        .kbShortcut(
            "c",
            modifier: .control
        ) {}
    }
}
