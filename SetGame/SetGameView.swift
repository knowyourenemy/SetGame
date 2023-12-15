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
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .matchedGeometryEffect(id: card.id, in: discardingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(8)
                    .rotationEffect(.degrees(card.matched == .matched ? 360 : 0))
                    .animation(.spin(duration: 1), value: card.matched)
                    .scaleEffect(card.matched == .incorrectlyMatched ? 1.05 : 1)
                    .animation(.scaleUpDown(duration: 0.5), value: card.matched)
                    .scaleEffect(card.matched == .matched ? 1 : 1)
                    .onTapGesture {
                        withAnimation {
                            viewModel.choose(card)
                        }

                    }
            }
            HStack {
                drawingDeck
                    .padding()
                Button("New Game") {
                    withAnimation {
                        viewModel.newGame()
                    }
                }
                .padding()
                discardingDeck
                    .padding()
            }
            
        }.padding()
    }
    
    
    @Namespace private var dealingNamespace
    @Namespace private var discardingNamespace
    
    private var drawingDeck: some View {
        ZStack {
            ForEach(viewModel.undealtCards){ undealtCard in
                CardView(card: undealtCard)
                    .matchedGeometryEffect(id: undealtCard.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .opacity))
                    
            }
        }
        .frame(width: 80.0, height: 80.0 / (2/3))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .strokeBorder(lineWidth: 2)
                .overlay(Text("Draw Pile")
                    .multilineTextAlignment(.center)
                )
        )
        .onTapGesture {
            withAnimation {
                viewModel.drawCards()
                
            }
        }
    }
    
    private var discardingDeck: some View {
        ZStack {
            ForEach(viewModel.discardedCards){ discardedCard in
                CardView(card: discardedCard)
                    .matchedGeometryEffect(id: discardedCard.id, in: discardingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .overlay(RoundedRectangle(cornerRadius: 12))
            }
        }
        .frame(width: 80.0, height: 80.0 / (2/3))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .strokeBorder(lineWidth: 2)
                .overlay(Text("Discard Pile")
                    .multilineTextAlignment(.center)
                )
        )
        .onTapGesture {
            withAnimation {
                viewModel.drawCards()
            }
        }
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

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .spring(duration: duration, bounce: 0.5)
    }
    
    static func scaleUpDown(duration: TimeInterval) -> Animation {
        .linear(duration: duration).repeatCount(2, autoreverses: true)
    }
    
    
}


#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
