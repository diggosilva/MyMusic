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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.tableView.reloadData()
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
                self.updateTableViewSmoothly()
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func updateTableViewSmoothly() {
        // Obter o índice do novo cliente
        let indexPath = IndexPath(row: viewModel.numberOfRowsInSection() - 1, section: 0)
        
        // Atualizar a tabela de forma suave
        gameView.tableView.beginUpdates()
        gameView.tableView.insertRows(at: [indexPath], with: .automatic)
        gameView.tableView.endUpdates()
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
        let client = viewModel.client
        let songVC = SongViewController(game: game, client: client)
        songVC.title = viewModel.cellForRowAt(indexPath: indexPath).title
        navigationController?.pushViewController(songVC, animated: true)
    }
}
