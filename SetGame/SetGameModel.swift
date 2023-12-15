//
//  SetGame.swift
//  SetGame
//
//  Created by Aaditya Patwari on 9/12/23.
//

import Foundation

struct SetGameModel {
    enum CardElementShape: CaseIterable {
        case rectangle
        case circle
        case diamond
    }
    
    enum CardElementColor: CaseIterable {
        case yellow
        case purple
        case blue
    }
    
    enum CardElementShade: CaseIterable {
        case filled
        case partial
        case empty
    }
    
    enum CardMatchedState {
        case unmatched
        case matched
        case incorrectlyMatched
    }
    
    private(set) var remainingCards: Array<Card> = []
    private(set) var openCards: Array<Card> = []
    private(set) var discardedCards: Array<Card> = []
    
    private let initialCardCount = 12
    
    
    init(){
        for count in 1...3 {
            for shape in CardElementShape.allCases {
                for color in CardElementColor.allCases {
                    for shade in CardElementShade.allCases {
                        remainingCards.append(Card(shape: shape, color: color, count: count, shade: shade))
                    }
                }
            }
        }
        remainingCards.shuffle()
        for _ in 0..<initialCardCount {
            openCards.append(remainingCards.removeLast())
        }
    }
    
    mutating func setMatchedForCardsIn(_ cards: Array<Card>, to newMatchedValue: CardMatchedState) {
        for card in cards {
            let cardIndex = openCards.firstIndex(of: card)
            openCards[cardIndex!].matched = newMatchedValue
        }
    }
    
    mutating func choose(_ card: Card){
        var selectedCards = openCards.filter { card in
            card.isSelected
        }
        if selectedCards.count >= 3 {
            for selectedCard in selectedCards {
                let selectedCardIndex = openCards.firstIndex(of: selectedCard)
                openCards[selectedCardIndex!].isSelected = false
                switch selectedCard.matched {
                case .incorrectlyMatched: openCards[selectedCardIndex!].matched = .unmatched
                case .matched:
                    if !remainingCards.isEmpty {
                        discardedCards.append(openCards[selectedCardIndex!])
                        openCards[selectedCardIndex!] = (remainingCards.removeLast())
                    }   else {
                        discardedCards.append(openCards.remove(at: selectedCardIndex!))
                    }
                case .unmatched: break
                }
            }
            selectedCards = []
        }
        
        let chosenCardIndex = openCards.firstIndex(of: card)
        if let chosenCardIndex = chosenCardIndex {
            openCards[chosenCardIndex].isSelected.toggle()
        }
        
        selectedCards = openCards.filter { card in
            card.isSelected
        }

        if selectedCards.count == 3 {
            // Check if successful match
            let counts = Set(selectedCards.map { card in
                card.count
            })
            let shapes = Set(selectedCards.map { card in
                card.shape
            })
            let shades = Set(selectedCards.map { card in
                card.shade
            })
            let colors = Set(selectedCards.map { card in
                card.color
            })
            
            if counts.count == 2 || shapes.count == 2 || shades.count == 2 || colors.count == 2 {
                // Unsuccessful match
                setMatchedForCardsIn(selectedCards, to: .incorrectlyMatched)
            } else {
                // Successful match
                setMatchedForCardsIn(selectedCards, to: .matched)
            }
        }
    }
    
    mutating func drawCards() {
        let selectedCards = openCards.filter { card in
            card.isSelected
        }
        if selectedCards.count == 3 && selectedCards.allSatisfy({ selectedCard in
            selectedCard.matched == .matched
        }) {
            for selectedCard in selectedCards {
                let selectedCardIndex = openCards.firstIndex(of: selectedCard)
                if let selectedCardIndex = selectedCardIndex {
                    discardedCards.append(openCards[selectedCardIndex])
                    openCards[selectedCardIndex] = remainingCards.removeLast()
                }
            }
        } else {
            for _ in 0..<3 {
                if !remainingCards.isEmpty {
                    openCards.append(remainingCards.removeLast())
                }
            }
        }
        
    }
    
    struct Card: Identifiable, Equatable, CustomDebugStringConvertible {
        var shape: CardElementShape
        var color: CardElementColor
        var count: Int
        var shade: CardElementShade
        
        var isSelected: Bool = false
        var matched: CardMatchedState = .unmatched
        
        var id: String { "\(shape):\(color):\(count):\(shade)"}
        
        static func == (lhs: Card, rhs: Card) -> Bool {
                return lhs.id == rhs.id
            }
        
        var debugDescription: String { id }
    }
}


