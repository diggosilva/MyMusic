//
//  Client.swift
//  MyMusic
//
//  Created by Diggo Silva on 21/10/24.
//

import Foundation

class Client: Codable {
    let name: String
    let games: [Game]
    
    init(name: String, games: [Game] = []) {
        self.name = name
        self.games = games
    }
}

class Game: Codable {
    let name: String
//    var price: Double {
//
//    }
    
    init(name: String/*, price: Double*/) {
        self.name = name
//        self.price = price
    }
}
