//
//  Repository.swift
//  MyMusic
//
//  Created by Diggo Silva on 23/10/24.
//

import Foundation

class Repository {
    let userDefaultsKey = "ClientKey"
    let userDefaults = UserDefaults.standard
    
    func loadClient() -> [Client] {
        if let data = userDefaults.data(forKey: userDefaultsKey) {
            if let decodedClient = try? JSONDecoder().decode([Client].self, from: data) {
                return decodedClient
            }
        }
        return []
    }
    
    func createUser(client: Client) {
        var clientList = loadClient()
        clientList.append(client)
        userDefaults.set(try? JSONEncoder().encode(clientList), forKey: userDefaultsKey)
    }
    
    func updateUser(client: Client) {
        let existingClients = loadClient()
        if let clientToEdit = existingClients.first(where: { $0.name == client.name && $0.id == client.id }) {
            clientToEdit.games = client.games
            userDefaults.set(try? JSONEncoder().encode(existingClients), forKey: userDefaultsKey)
        }
    }
}
