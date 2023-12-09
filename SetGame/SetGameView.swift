//
//  SetGameView.swift
//  SetGame
//
//  Created by Aaditya Patwari on 9/12/23.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel: SetGameViewModel
    
    var body: some View {
        AspectVGrid(viewModel.cards, aspectRatio: 2/3) { card in
            CardView(card: card)
                .padding(4)
        }
    }
}

struct CardView: View {
    let card: SetGameModel.Card
    
    private var elementColor: Color {
        switch card.color {
        case .red:
            Color.red
        case .green:
            Color.green
        case .blue:
            Color.blue
        }
    }
    
    @ViewBuilder
    private func drawShape(_ shape: SetGameModel.CardElementShape, shade: SetGameModel.CardElementShade) -> some View {
        switch shape {
        case .circle: applyShade(shade, to: Circle())
        case .diamond: applyShade(shade, to: Rectangle())
        case .rectangle: applyShade(shade, to: RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
        }
    }
    
    @ViewBuilder
    private func applyShade<CardElementShape: Shape>(_ shade:SetGameModel.CardElementShade, to shape: CardElementShape) -> some View {
        switch shade {
        case .empty: shape.stroke()
        case .partial: shape.fill().opacity(0.5)
        case .filled: shape.fill()
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).stroke()
            VStack() {
                ForEach(0..<card.count, id: \.self) { _ in
                    drawShape(card.shape, shade: card.shade)
                        .aspectRatio(2, contentMode: .fit)
                }
            }
            .foregroundColor(elementColor)
            .padding(10)
        }
        .aspectRatio(2/3, contentMode: .fill)
    }
}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
