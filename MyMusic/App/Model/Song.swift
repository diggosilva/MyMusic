//
//  Song.swift
//  MyMusic
//
//  Created by Diggo Silva on 02/11/24.
//


class Song: Codable {
    var title: String
    var price: Double
    
    init(title: String, price: Double) {
        self.title = title
        self.price = price
    }
}