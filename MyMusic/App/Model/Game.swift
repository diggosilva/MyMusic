//
//  Game.swift
//  MyMusic
//
//  Created by Diggo Silva on 02/11/24.
//


class Game: Codable {
    var title: String
    var songs: [Song]
    var totalPrice: Double
    
    init(title: String, songs: [Song] = [], totalPrice: Double = 0.0) {
        self.title = title
        self.songs = songs
        self.totalPrice = totalPrice
    }
}