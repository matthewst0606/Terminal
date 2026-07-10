import SwiftUI

enum ANSIParser {
    static func attributedString(from text: String) -> AttributedString {
        var result = AttributedString()
        var current = Style()
        var buffer = ""
        var index = text.startIndex

        func flushBuffer() {
            guard !buffer.isEmpty else { return }

            var run = AttributedString(buffer)
            current.apply(to: &run)
            result += run
            buffer = ""
        }

        while index < text.endIndex {
            guard text[index] == "\u{001B}" else {
                buffer.append(text[index])
                index = text.index(after: index)
                continue
            }

            let escapeStart = index
            let nextIndex = text.index(after: index)
            guard nextIndex < text.endIndex, text[nextIndex] == "[" else {
                buffer.append(text[escapeStart])
                index = nextIndex
                continue
            }

            var sequenceEnd = text.index(after: nextIndex)
            while sequenceEnd < text.endIndex, text[sequenceEnd] != "m" {
                sequenceEnd = text.index(after: sequenceEnd)
            }

            guard sequenceEnd < text.endIndex else {
                buffer.append(contentsOf: text[escapeStart...])
                break
            }

            flushBuffer()

            let codeText = String(text[text.index(after: nextIndex)..<sequenceEnd])
            let codes = codeText
                .split(separator: ";")
                .compactMap { Int($0) }

            current.update(with: codes.isEmpty ? [0] : codes)
            index = text.index(after: sequenceEnd)
        }

        flushBuffer()
        return result
    }
}

private struct Style {
    var foregroundColor: Color?
    var isBold = false
    var isItalic = false

    mutating func update(with codes: [Int]) {
        for code in codes {
            switch code {
            case 0:
                self = Style()
            case 1:
                isBold = true
            case 3:
                isItalic = true
            case 22:
                isBold = false
            case 23:
                isItalic = false
            case 30...37, 90...97:
                foregroundColor = Self.color(for: code)
            case 39:
                foregroundColor = nil
            default:
                break
            }
        }
    }

    func apply(to text: inout AttributedString) {
        if let foregroundColor {
            text.foregroundColor = foregroundColor
        }

        if isBold && isItalic {
            text.inlinePresentationIntent = [
                .stronglyEmphasized,
                .emphasized
            ]
        } else if isBold {
            text.inlinePresentationIntent = .stronglyEmphasized
        } else if isItalic {
            text.inlinePresentationIntent = .emphasized
        }
    }

    private static func color(for code: Int) -> Color? {
        switch code {
        case 30: return .black
        case 31: return .red
        case 32: return .green
        case 33: return .yellow
        case 34: return .blue
        case 35: return .purple
        case 36: return .cyan
        case 37: return .white
        case 90: return .gray
        case 91: return .red
        case 92: return .green
        case 93: return .yellow
        case 94: return .blue
        case 95: return .purple
        case 96: return .cyan
        case 97: return .white
        default: return nil
        }
    }
}
