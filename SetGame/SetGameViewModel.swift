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
        return model.openCards
    }
    
    var undealtCards: Array<SetGameModel.Card>{
        return model.remainingCards
    }
    
    var discardedCards: Array<SetGameModel.Card>{
        return model.discardedCards
    }
    
    var allCardsDealt: Bool {
        return model.remainingCards.isEmpty
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


