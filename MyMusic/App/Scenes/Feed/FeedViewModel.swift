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
        if listClient.isEmpty {
            listClient.append(Client(name: clientName))
            repository.saveClient(client: listClient)
        } else {
            let newClient = Client(name: clientName)
            listClient.append(newClient)
            repository.saveClient(client: listClient)
        }
    }
    
    func loadClient() {
        if let loadedClient = repository.loadClient() {
            listClient = loadedClient
        }
    }
}

//MARK: REPOSITORY

class Repository {
    let userDefaultsKey = "ClientKey"
    let userDefaults = UserDefaults.standard
    
    func saveClient(client: [Client]) {
        if let encodedClient = try? JSONEncoder().encode(client) {
            userDefaults.set(encodedClient, forKey: userDefaultsKey)
        }
    }
    
    func loadClient() -> [Client]? {
        if let data = userDefaults.data(forKey: userDefaultsKey) {
            if let decodedClient = try? JSONDecoder().decode([Client].self, from: data) {
                return decodedClient
            }
        }
        return []
    }
}
