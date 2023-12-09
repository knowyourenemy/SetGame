//
//  SetGame.swift
//  SetGame
//
//  Created by Aaditya Patwari on 9/12/23.
//

import Foundation

struct SetGameModel {
    private var cards: Array<Card> = []
    
    struct Card {
        var shape: String
        var color: String
        var count: Int
        var shade: Shade
        
        enum Shade: Double, CaseIterable {
            case filled = 1
            case partiallyFilled = 0.3
            case empty = 0
        }
    }
    
    init(){
        for count in 1...3 {
            for shade in Card.Shade.allCases {
                for color in ["red", "green", "blue"] {
                    for shape in ["rectangle", "circle", "square"] {
                        cards.append(Card(shape: shape, color: color, count: count, shade: shade))
                    }
                }
            }
        }
    }
}


