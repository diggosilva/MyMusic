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
    var songs: [Song]
//    var price: Double
    
    init(title: String, songs: [Song] = []/*, price: Double = 0.0*/) {
        self.title = title
        self.songs = songs
//        self.price = price
    }
}

class Song: Codable {
    let title: String
    let price: Double
    
    init(title: String, price: Double) {
        self.title = title
        self.price = price
    }
}
