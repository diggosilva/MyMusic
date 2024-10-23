//
//  GameViewController.swift
//  MyMusic
//
//  Created by Diggo Silva on 23/10/24.
//

import UIKit

class GameViewController: UIViewController {
    
    let gameView = GameView()
    
    override func loadView() {
        super.loadView()
        view = gameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSources()
    }
    
    private func setNavBar() {
        title = "Jogos"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addGameAlert))
    }
    
    private func setDelegatesAndDataSources() {
        gameView.tableView.delegate = self
        gameView.tableView.dataSource = self
    }
    
    @objc func addGameAlert() {
        print("addGameAlert")
    }
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.identifier, for: indexPath) as! GameCell
//        cell.textLabel?.text = "Game \(indexPath.row)"
        cell.gameName.text = "Game \(indexPath.row)"
        cell.gamePrice.text = "R$ 100,00"
        return cell
    }
}
