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

    
    // MARK: - Intents
    
    func choose(_ card: SetGameModel.Card) {
        model.choose(card)
    }
}


