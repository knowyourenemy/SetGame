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
    
    enum CardDealtState {
        case undealt
        case dealt
        case discarded
    }
    
//    private(set) var remainingCards: Array<Card> = []
//    private(set) var openCards: Array<Card> = []
//    private(set) var discardedCards: Array<Card> = []
    private(set) var cards: Array<Card> = []
    
    private let initialCardCount = 12
    private var currentDealtIndex = 0
    
    
    init(){
        for count in 1...3 {
            for shape in CardElementShape.allCases {
                for color in CardElementColor.allCases {
                    for shade in CardElementShade.allCases {
                        cards.append(Card(shape: shape, color: color, count: count, shade: shade))
                    }
                }
            }
        }
        cards.shuffle()
        for cardIndex in 0..<initialCardCount {
            cards[cardIndex].dealt = .dealt
            currentDealtIndex += 1
        }
    }
    
    mutating func setMatchedForCardsIn(_ selectedCards: Array<Card>, to newMatchedValue: CardMatchedState) {
        for card in selectedCards {
            let cardIndex = cards.firstIndex(of: card)
            cards[cardIndex!].matched = newMatchedValue
        }
    }
    
    mutating func choose(_ card: Card){
        var selectedCards = cards.filter { card in
            card.isSelected
        }
        if selectedCards.count >= 3 {
            for selectedCard in selectedCards {
                let selectedCardIndex = cards.firstIndex(of: selectedCard)
                cards[selectedCardIndex!].isSelected = false
                switch selectedCard.matched {
                case .incorrectlyMatched: cards[selectedCardIndex!].matched = .unmatched
                case .matched:
                    if currentDealtIndex < cards.count {
                        cards[selectedCardIndex!].dealt = .discarded
                        cards[currentDealtIndex].dealt = .dealt
                        cards.swapAt(selectedCardIndex!, currentDealtIndex)
                        currentDealtIndex += 1
//                        discardedCards.append(openCards[selectedCardIndex!])
//                        openCards[selectedCardIndex!] = (remainingCards.removeLast())
                    }   else {
                        cards[selectedCardIndex!].dealt = .discarded
                    }
                case .unmatched: break
                }
            }
            selectedCards = []
        }
        
        let chosenCardIndex = cards.firstIndex(of: card)
        if let chosenCardIndex = chosenCardIndex {
            cards[chosenCardIndex].isSelected.toggle()
        }
        
        selectedCards = cards.filter { card in
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
        print("hellp?")
        let selectedCards = cards.filter { card in
            card.isSelected
        }
        if selectedCards.count == 3 && selectedCards.allSatisfy({ selectedCard in
            selectedCard.matched == .matched
        }) {
            for selectedCard in selectedCards {
                let selectedCardIndex = cards.firstIndex(of: selectedCard)
                if let selectedCardIndex = selectedCardIndex {
                    cards[selectedCardIndex].isSelected = false
                    if currentDealtIndex < cards.count {
                        cards[selectedCardIndex].dealt = .discarded
                        cards[currentDealtIndex].dealt = .dealt
                        cards.swapAt(selectedCardIndex, currentDealtIndex)
                        currentDealtIndex += 1
                    }
                }
            }
        } else {
            for _ in 0..<3 {
                if currentDealtIndex < cards.count {
                    cards[currentDealtIndex].dealt = .dealt
                    currentDealtIndex += 1
                    print(currentDealtIndex)
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
        var dealt: CardDealtState = .undealt
        
        var id: String { "\(shape):\(color):\(count):\(shade)"}
        
        static func == (lhs: Card, rhs: Card) -> Bool {
                return lhs.id == rhs.id
            }
        
        var debugDescription: String { id }
    }
}


