//
//  GameViewModel.swift
//  MyMusic
//
//  Created by Diggo Silva on 23/10/24.
//

import Foundation

protocol GameViewModelProtocol {
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> Game
}

class GameViewModel: GameViewModelProtocol {
    let userDefaultsKey = "userDefaultsKey"
    let userDefaults = UserDefaults.standard
    var listGame: [Game] = []
    let client: Client
    
    init(client: Client) {
        self.client = client
//        self.listGame = client.games  // Sugestao xcode
    }
    
    func numberOfRowsInSection() -> Int {
        listGame.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Game {
        listGame[indexPath.row]
    }
}
