//
//  GameViewController.swift
//  MyMusic
//
//  Created by Diggo Silva on 23/10/24.
//

import UIKit

class GameViewController: UIViewController {
    let gameView = DefaultView()
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
        registerCells()
        longPressRecognizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameView.tableView.reloadData()
    }
    
    private func longPressRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        gameView.tableView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc private func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let location = gestureRecognizer.location(in: gameView.tableView)
            if let indexPath = gameView.tableView.indexPathForRow(at: location) {
                let game = viewModel.cellForRowAt(indexPath: indexPath)
                self.editGameAlert(game: game, indexPath: indexPath)
            }
        }
    }
    
    private func editGameAlert(game: Game, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Editar jogo", message: "Atualize o nome do jogo.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = game.title
            textField.configTextField(textField: textField, placeholder: "Nome do Jogo")
        }
        
        let saveAction = UIAlertAction(title: "Salvar", style: .default) { action in
            if let gameTitle = alert.textFields?.first?.text, !gameTitle.isEmpty {
                self.viewModel.updateGame(at: indexPath.row, newGameTitle: gameTitle)
                self.updateTableViewSmoothlyForUpdateGame(at: indexPath)
            }
        }
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func setNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addGameAlert))
    }
    
    private func setDelegatesAndDataSources() {
        gameView.tableView.delegate = self
        gameView.tableView.dataSource = self
    }
    
    private func registerCells() {
        gameView.registerCell(cellType: GameCell.self, identifier: GameCell.identifier)
    }
    
    @objc func addGameAlert() {
        let alert = UIAlertController(title: "Adicionar Jogo", message: "Insira o nome do Jogo", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.configTextField(textField: textField, placeholder: "Nome do Jogo")
        }
        
        let addAction = UIAlertAction(title: "Adicionar", style: .default) { action in
            if let gameTitle = alert.textFields?.first?.text, !gameTitle.isEmpty {
                self.viewModel.addGame(gameTitle: gameTitle)
                self.updateTableViewSmoothlyForNewGame()
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func updateTableViewSmoothlyForNewGame() {
        // Obter o índice do novo cliente
        let indexPath = IndexPath(row: viewModel.numberOfRowsInSection() - 1, section: 0)
        
        // Atualizar a tabela de forma suave
        gameView.tableView.beginUpdates()
        gameView.tableView.insertRows(at: [indexPath], with: .automatic)
        gameView.tableView.endUpdates()
    }
    
    private func updateTableViewSmoothlyForUpdateGame(at indexPath: IndexPath) {
        gameView.tableView.beginUpdates()
        gameView.tableView.reloadRows(at: [indexPath], with: .automatic)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "", message: "Isso apagará permanentemente o jogo selecionado. Esta ação não pode ser desfeita.", preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Apagar Deste iPhone", style: .destructive) { action in
                let game = self.viewModel.cellForRowAt(indexPath: indexPath)
                self.viewModel.removeGame(game: game)
                self.gameView.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            alert.addAction(deleteAction)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
}
