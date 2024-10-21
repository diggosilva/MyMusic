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
}

class FeedViewModel: FeedViewModelProtocol {
    let listClient: [Client] = []
    
    func numberOfRowsInSection() -> Int {
        return listClient.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Client {
        return listClient[indexPath.row]
    }
}
