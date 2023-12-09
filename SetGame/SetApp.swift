//
//  SetApp.swift
//  SetGame
//
//  Created by Aaditya Patwari on 9/12/23.
//

import SwiftUI

@main
struct SetApp: App {
    @StateObject var viewModel = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
            SetGameView(viewModel: viewModel)
        }
    }
}
