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
        let game = viewModel.cellForRowAt(indexPath: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GameCell.identifier, for: indexPath) as? GameCell else { return UITableViewCell() }
        cell.configure(game: game)
        return cell
    }
}

class SongView: UIView {
    lazy var tableview: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy () {
        backgroundColor = .systemBackground
        addSubview(tableview)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableview.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
