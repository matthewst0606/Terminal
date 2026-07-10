//
//  OverlayButtonExtension.swift
//  Terminal++
//
//  Created by Matt on 7/3/26.
//

import SwiftUI

extension OverlayButton {
    
    var SmallButton: some View {
        formatSymbol(
            fontSize: 18,
            buttonRadius: 4,
            paddingSize: 2
        )
    }
    
    
    var LargeButton: some View {
        HStack {
            formatSymbol(
                fontSize: 20,
                buttonRadius: 10,
                paddingSize: 4
            )
        }
    }
    
    
    
    func formatSymbol(
        fontSize: CGFloat,
        buttonRadius: CGFloat,
        paddingSize: CGFloat,
    ) -> some View {
        
        return HStack {
            
            Symbol(
                item.image,
                font: .system(size: fontSize),
                render: .multicolor,
                gradient: .gradient
            )
            .frame(maxWidth: 25, maxHeight: 25)
            
            
            if item.title != nil {
                formatText()
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: buttonRadius))
        .padding(paddingSize)

        
        .bgRect(backgroundColor, radius: buttonRadius)
    }
    
    
    
    func formatText() -> some View {
        return Text(item.title!)
            .font(.system(size: 14))
            .frame(maxWidth: .infinity, alignment: .leading)
            .neswPadding(10, 10, 10, 0)
    }
    
    var backgroundColor: Color {
        switch true {
        case isSelected:  return Color(nsColor: .systemBlue).opacity(0.5)
        default:          return Color.clear
            
        }
    }
}
