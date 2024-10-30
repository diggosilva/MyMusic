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
    func addGame(gameTitle: String)
}

class GameViewModel: GameViewModelProtocol {
    let client: Client
    private let repository = Repository()
    
    init(client: Client) {
        self.client = client
    }
    
    func numberOfRowsInSection() -> Int {
        client.games.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Game {
        client.games[indexPath.row]
    }
    
    func addGame(gameTitle: String) {
        let game = Game(title: gameTitle)
        client.games.append(game)
        repository.updateUser(client: client)
    }
}
