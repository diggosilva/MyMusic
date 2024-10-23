//
//  FeedViewController.swift
//  MyMusic
//
//  Created by Diggo Silva on 20/10/24.
//

import UIKit

class FeedViewController: UIViewController {
    
    let feedView = FeedView()
    lazy var viewModel: FeedViewModelProtocol = FeedViewModel()
    
    override func loadView() {
        super.loadView()
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSources()
        loadClients()
    }
    
    private func setNavBar() {
        title = "Clientes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addClientAlert))
    }
    
    private func setDelegatesAndDataSources() {
        feedView.tableView.delegate = self
        feedView.tableView.dataSource = self
    }
    
    private func loadClients() {
        viewModel.loadClient()
        feedView.tableView.reloadData()
    }
    
    @objc func addClientAlert() {
        let alert = UIAlertController(title: "Adicionar Cliente", message: "Insira o nome do cliente", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Nome do cliente"
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .no
            textField.clearButtonMode = .whileEditing
        }
        
        let addAction = UIAlertAction(title: "Adicionar", style: .default) { action in
            if let clientName = alert.textFields?.first?.text, !clientName.isEmpty {
                // Adiciona o cliente na lista
                self.viewModel.addClient(clientName: clientName)
                self.feedView.tableView.reloadData()
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else { return UITableViewCell() }
        let client = viewModel.cellForRowAt(indexPath: indexPath)
        cell.configure(client: client)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let client = viewModel.cellForRowAt(indexPath: indexPath)
        navigationController?.pushViewController(GameViewController(), animated: true)
    }
}

class GameView: UIView {
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(GameCell.self, forCellReuseIdentifier: GameCell.identifier)
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
        addSubview(tableView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

class GameCell: UITableViewCell {
    static let identifier: String = "GameCell"
    
    lazy var gameName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .preferredFont(forTextStyle: .headline)
        lbl.text = "Game Name"
        return lbl
    }()
    
    lazy var gamePrice: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .preferredFont(forTextStyle: .subheadline)
        lbl.text = "R$ 4500,00"
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(game: Game) {
        gameName.text = "Game Name"
        gamePrice.text = "R$ 4500,00"
        self.accessoryType = .disclosureIndicator
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy () {
        backgroundColor = .systemBackground
        addSubview(gameName)
        addSubview(gamePrice)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            gameName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            gameName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            gameName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            gamePrice.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 10),
            gamePrice.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            gamePrice.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            gamePrice.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}

protocol GameViewModelProtocol {
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> Game
}

class GameViewModel: GameViewModelProtocol {
    let userDefaultsKey = "userDefaultsKey"
    let userDefaults = UserDefaults.standard
    var listGame: [Game] = []
    let client: Client
    
    init(client: Client) {
        self.client = client
//        self.listGame = client.games  // Sugestao xcode
    }
    
    func numberOfRowsInSection() -> Int {
        listGame.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Game {
        listGame[indexPath.row]
    }
}
