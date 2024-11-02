//
//  Client.swift
//  MyMusic
//
//  Created by Diggo Silva on 21/10/24.
//

import Foundation

class Client: Codable {
    let id: UUID
    let name: String
    var games: [Game]
    
    init(name: String, games: [Game] = []) {
        self.id = UUID()
        self.name = name
        self.games = games
    }
}
