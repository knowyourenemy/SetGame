//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Aaditya Patwari on 9/12/23.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var model = SetGameModel()
    
    var openCards: Array<SetGameModel.Card> {
        return model.cards.filter { card in
            card.dealt == .dealt
        }
    }
    
    var undealtCards: Array<SetGameModel.Card>{
        return model.cards.filter { card in
            card.dealt == .undealt
        }
    }
    
    var discardedCards: Array<SetGameModel.Card>{
        return model.cards.filter { card in
            card.dealt == .discarded
        }
    }
    
    // MARK: - Intents
    
    func choose(_ card: SetGameModel.Card) {
        model.choose(card)
    }
    
    func drawCards() {
        model.drawCards()
    }
    
    func newGame(){
        model = SetGameModel()
    }
}


