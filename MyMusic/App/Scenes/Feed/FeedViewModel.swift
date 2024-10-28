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
    func addClient(clientName: String)
    func loadClient()
}

class FeedViewModel: FeedViewModelProtocol {
    var listClient: [Client] = []
    let repository = Repository()
    
    func numberOfRowsInSection() -> Int {
        return listClient.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Client {
        return listClient[indexPath.row]
    }
    
    func addClient(clientName: String) {
        let newClient = Client(name: clientName)
        listClient.append(newClient)
        repository.criarNovoCNPJ(client: newClient)
    }
    
    func loadClient() {
        listClient = repository.loadClient()
    }
}
