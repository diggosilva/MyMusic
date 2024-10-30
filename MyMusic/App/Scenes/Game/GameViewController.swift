//
//  GameViewController.swift
//  MyMusic
//
//  Created by Diggo Silva on 23/10/24.
//

import UIKit

class GameViewController: UIViewController {
    
    let gameView = GameView()
    let viewModel: GameViewModelProtocol
    
    init(client: Client) {
        self.viewModel = GameViewModel(client: client)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addGameAlert))
    }
    
    private func setDelegatesAndDataSources() {
        gameView.tableView.delegate = self
        gameView.tableView.dataSource = self
    }
    
    @objc func addGameAlert() {
        let alert = UIAlertController(title: "Adicionar Jogo", message: "Insira o nome do Jogo", preferredStyle: .alert)
        
        alert.addTextField { textfield in
            textfield.placeholder = "Nome do Jogo"
            textfield.autocapitalizationType = .words
            textfield.autocorrectionType = .no
            textfield.clearButtonMode = .whileEditing
        }
        
        let addAction = UIAlertAction(title: "Adicionar", style: .default) { action in
            if let gameTitle = alert.textFields?.first?.text, !gameTitle.isEmpty {
                self.viewModel.addGame(gameTitle: gameTitle)
                self.gameView.tableView.reloadData()
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension GameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.identifier, for: indexPath) as? GameCell else { return UITableViewCell() }
        let game = viewModel.cellForRowAt(indexPath: indexPath)
        cell.configure(game: game)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let game = viewModel.cellForRowAt(indexPath: indexPath)
        let songVC = SongViewController(game: game)
        songVC.title = viewModel.cellForRowAt(indexPath: indexPath).title
        navigationController?.pushViewController(songVC, animated: true)
    }
}

class SongViewController: UIViewController {
    
    let songView = SongView()
    let viewModel: SongViewModelProtocol
    
    init(game: Game) {
        self.viewModel = SongViewModel(game: game)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = songView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSources()
    }
    
    private func setNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSongAlert))
    }
    
    private func setDelegatesAndDataSources() {
        self.songView.tableview.delegate = self
        self.songView.tableview.dataSource = self
    }
    
    @objc private func addSongAlert() {
        let alert = UIAlertController(title: "Adicionar música", message: "Insira o nome e o valor da música", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Nome da música"
            textField.clearButtonMode = .whileEditing
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .no
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Valor da música"
            textField.clearButtonMode = .whileEditing
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .no
            textField.keyboardType = .decimalPad
        }
        
        let addAction = UIAlertAction(title: "Adicionar", style: .default) { action in
            if let songTitle = alert.textFields?.first?.text, !songTitle.isEmpty,
               let songPrice = alert.textFields?.last?.text, !songPrice.isEmpty {
                self.viewModel.addSong(songTitle: songTitle, songPrice: songPrice)
                self.songView.tableview.reloadData()
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension SongViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongCell.identifier, for: indexPath) as? SongCell else { return UITableViewCell() }
        let song = viewModel.cellForRowAt(indexPath: indexPath)
        cell.configure(song: song)
        return cell
    }
}

protocol SongViewModelProtocol {
    func numberOfRowsInSection()  -> Int
    func cellForRowAt(indexPath: IndexPath) -> Song
    func addSong(songTitle: String, songPrice: String)
}

class SongViewModel: SongViewModelProtocol {
    let game: Game
    let repository = Repository()
    
    init(game: Game) {
        self.game = game
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
//        repository.updateUser(client: <#T##Client#>)
    }
}
