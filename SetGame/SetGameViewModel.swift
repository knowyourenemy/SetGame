//
//  SetGameViewModel.swift
//  SetGame
//
//  Created by Aaditya Patwari on 9/12/23.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published private var model = SetGameModel()
    
    var cards: Array<SetGameModel.Card> {
        return model.cards
    }
}


