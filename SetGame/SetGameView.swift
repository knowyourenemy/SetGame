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
        VStack {
            AspectVGrid(viewModel.openCards, aspectRatio: 2/3) { card in
                CardView(card: card)
                    .padding(8)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
                    .animation(.default, value: viewModel.openCards)
            }.animation(.default, value: viewModel.openCards)
            HStack {
                Button("Draw Three") {
                    viewModel.drawCards()
                }
                .disabled(viewModel.allCardsDealt)
                .padding()
                Button("New Game") {
                    viewModel.newGame()
                }
                .padding()
            }
            
        }.padding()
    }
}

struct CardView: View {
    let card: SetGameModel.Card
    
    private var elementColor: Color {
        switch card.color {
        case .yellow:
            Color.yellow
        case .purple:
            Color.purple
        case .blue:
            Color.blue
        }
    }
    
    @ViewBuilder
    private func drawShape(_ shape: SetGameModel.CardElementShape, shade: SetGameModel.CardElementShade) -> some View {
        switch shape {
        case .circle: applyShade(shade, to: Circle())
        case .diamond: applyShade(shade, to: Diamond())
        case .rectangle: applyShade(shade, to: RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
        }
    }
    
    @ViewBuilder
    private func applyShade<CardElementShape: Shape>(_ shade:SetGameModel.CardElementShade, to shape: CardElementShape) -> some View {
        switch shade {
        case .empty: shape.stroke()
        case .partial: shape.fill().opacity(0.3)
        case .filled: shape.fill()
        }
    }
    
    var body: some View {
        var backgroundColor: Color {
            switch card.matched {
            case .unmatched: Color.white
            case .matched: Color.green.opacity(0.2)
            case .incorrectlyMatched: Color.red.opacity(0.2)
            }
        }
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .stroke()
                .foregroundColor(card.isSelected ? .blue : .black)
                .background(RoundedRectangle(cornerRadius: 12).fill(backgroundColor))
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
