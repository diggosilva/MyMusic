//
//  Client.swift
//  MyMusic
//
//  Created by Diggo Silva on 21/10/24.
//

import Foundation

class Client: Codable {
    let name: String
    var games: [Game]
    
    init(name: String, games: [Game] = []) {
        self.name = name
        self.games = games
    }
}

class Game: Codable {
    let title: String
//    var price: Double
    
    init(title: String/*, price: Double = 0.0*/) {
        self.title = title
//        self.price = price
    }
}

class Song: Codable {
    let title: String
    
    init(title: String) {
        self.title = title
    }
}
