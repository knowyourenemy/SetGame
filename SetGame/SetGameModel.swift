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
        case red
        case green
        case blue
    }
    
    enum CardElementShade: CaseIterable {
        case filled
        case partial
        case empty
    }
    
    private(set) var cards: Array<Card> = []
    
    struct Card: Identifiable {
        var shape: CardElementShape
        var color: CardElementColor
        var count: Int
        var shade: CardElementShade
        
        var id: String { "\(shape):\(color):\(count):\(shade)"}
    }
    
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
    }
}


