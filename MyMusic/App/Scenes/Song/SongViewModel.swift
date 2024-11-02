//
//  SongViewModelProtocol.swift
//  MyMusic
//
//  Created by Diggo Silva on 30/10/24.
//

import Foundation

protocol SongViewModelProtocol {
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> Song
    func addSong(songTitle: String, songPrice: String)
    func removeSong(song: Song)
}

class SongViewModel: SongViewModelProtocol {
    let game: Game
    private let repository: Repository
    private var client: Client
    
    init(game: Game, client: Client, repository: Repository = Repository()) {
        self.game = game
        self.client = client
        self.repository = repository
    }
    
    func numberOfRowsInSection() -> Int {
        return game.songs.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Song {
        return game.songs[indexPath.row]
    }
    
    func addSong(songTitle: String, songPrice: String) {
        let song = Song(title: songTitle, price: Double(songPrice) ?? 0.0)
        game.songs.append(song)
        repository.updateUser(client: client)
    }
    
    func removeSong(song: Song) {
        game.songs.removeAll(where: { $0.title == song.title })
        repository.updateUser(client: client)
    }
}
