//
//  SetGameView.swift
//  SetGame
//
//  Created by Aaditya Patwari on 9/12/23.
//

import SwiftUI

struct SetGameView: View {
    var body: some View {
        ForEach(0..<3) { _ in
            CardView(
                shape: Rectangle(),
                count: 2,
                color: .orange,
                shade: .filled)
        }
        
    }
}


enum Shade: Double {
    case filled = 1
    case partiallyFilled = 0.3
    case empty = 0
}

struct CardView<ItemShape: Shape>: View {
    let shape: ItemShape
    let count: Int
    let color: Color
    let shade: Shade
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
            VStack() {
                ForEach(0..<count, id: \.self) { _ in
                    shape.aspectRatio(2, contentMode: .fit)
                }
            }.foregroundColor(color)
                .opacity(shade.rawValue)
                .padding(10)
        }
        .aspectRatio(2/3, contentMode: .fit)
        .foregroundColor(.gray)
    }
}

#Preview {
    SetGameView()
}
