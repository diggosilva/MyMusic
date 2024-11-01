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
    func removeClient(client: Client)
    func loadClient()
}

class FeedViewModel: FeedViewModelProtocol {
    var listClient: [Client] = []
    private let repository: Repository
    
    init(repository: Repository = Repository()) {
        self.repository = repository
    }
    
    func numberOfRowsInSection() -> Int {
        return listClient.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Client {
        return listClient[indexPath.row]
    }
    
    func addClient(clientName: String) {
        let newClient = Client(name: clientName)
        listClient.append(newClient)
        repository.createUser(client: newClient)
    }
    
    func removeClient(client: Client) {
        if let index = listClient.firstIndex(where: { $0.id == client.id }) {
            listClient.remove(at: index)
            repository.deleteUser(client: client)
        }
    }
    
    func loadClient() {
        listClient = repository.loadClient()
    }
}
