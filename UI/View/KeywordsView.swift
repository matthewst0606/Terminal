//
//  KeywordsView.swift
//  Terminal++
//
//  Created by Matt on 6/29/26.
//

import SwiftUI


struct KeywordsView: View {
    @AppStorage("keywords") private var input = ""
    private let defaultItems: [KeywordItem] = [
        KeywordItem(lhs: "cmd", rhs: "cmd"),
        KeywordItem(lhs: "cmd2", rhs: "cmd2"),
        KeywordItem(lhs: "clear", rhs: "clear"),
        KeywordItem(lhs: "help", rhs: "help")
    ]
    
    
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Default")
                        .font(.title2)
                    Symbol(
                        name: "command.square.fill",
                        font: .system(size: 24),
                        render: .hierarchical
                    )
                }
                .neswPadding(10, 0, 0, 0)

                List {
                    ForEach(defaultItems) { item in
                        ListItem(lhs: item.lhs, rhs: item.rhs)
                    }

                }
                .scrollContentBackground(.hidden)
                .frame(height: 200)
                .glassRect(radius: 10, padding: 10)

            }
            .bgRect(
                NSColor.quaternarySystemFill,
                radius: 10,
                padding: 10
            )

            VStack {
                HStack {
                    Text("Custom")
                        .font(.title2)
                    Symbol(
                        name: "keyboard.badge.ellipsis.fill",
                        font: .title2,
                        render: .hierarchical
                    )
                }.padding()

                HStack {
                    Text("New Keyword:")
                        .font(.default)
                    TextField("", text: $input)
                        .onSubmit { }
                        .textFieldStyle(.plain)
                        .padding(10)
                        .glassRect(radius: 10)

                }.padding()
            }
            .bgRect(
                NSColor.quaternarySystemFill,
                radius: 10,
                padding: 10
            )
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .textSelection(.enabled)
    }
        
    
    
    private func listItems() -> [KeywordItem] {
        [
            KeywordItem(lhs: "cmd", rhs: "cmd"),
            KeywordItem(lhs: "cmd", rhs: "cmd"),
            KeywordItem(lhs: "cmd", rhs: "cmd"),
            KeywordItem(lhs: "cmd", rhs: "cmd")
        ]
    }
}




struct KeywordItem: Identifiable {
    let lhs: String
    let rhs: String
    var id: String {
        "\(lhs)-\(rhs)"
    }
}

struct ListItem: View {
    let lhs: String
    let rhs: String
    
    var body: some View {
        HStack {
            Text(lhs)
            Spacer()
            Text(rhs)
        }
    }

}
