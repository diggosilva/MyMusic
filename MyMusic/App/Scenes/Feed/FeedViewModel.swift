//
//  FeedViewModel.swift
//  MyMusic
//
//  Created by Diggo Silva on 21/10/24.
//

import Foundation

protocol FeedViewModelProtocol {
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> Client
    func addClient(client: Client)
}

class FeedViewModel: FeedViewModelProtocol {
    var listClient: [Client] = []
    
    func numberOfRowsInSection() -> Int {
        return listClient.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Client {
        return listClient[indexPath.row]
    }
    
    func addClient(client: Client) {
        listClient.append(client)
    }
}
