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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let songVC = SongViewController()
        songVC.title = viewModel.cellForRowAt(indexPath: indexPath).title
        navigationController?.pushViewController(songVC, animated: true)
    }
}

class SongView: UIView {
    lazy var tableview: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(SongCell.self, forCellReuseIdentifier: SongCell.identifier)
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

class SongViewController: UIViewController {
    
    let songView = SongView()
    
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
            if let songName = alert.textFields?.first?.text, !songName.isEmpty,
               let songPrice = alert.textFields?.last?.text, !songPrice.isEmpty {
                let song = Song(title: songName, price: Double(songPrice) ?? 0.0)
                print("DEBUG: \(song.title) - \(song.price)")
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension SongViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SongCell.identifier, for: indexPath) as? SongCell else { return UITableViewCell() }
//        cell.textLabel?.text = "Música \(indexPath.row)"
        return cell
    }
}

class SongCell: UITableViewCell {
    static let identifier: String = "SongCell"
    
    lazy var songName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .preferredFont(forTextStyle: .headline)
        lbl.numberOfLines = 0
        lbl.text = "Música"
        return lbl
    }()
    
    lazy var songPrice: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .preferredFont(forTextStyle: .subheadline)
        lbl.text = "$ 250.00"
        lbl.textColor = .white
        return lbl
    }()
    
    lazy var songPriceBG: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 14
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(song: Song) {
        songName.text = song.title
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy () {
        addSubview(songName)
        addSubview(songPriceBG)
        songPriceBG.addSubview(songPrice)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            songName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            songName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            songName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            songPriceBG.topAnchor.constraint(equalTo: songName.bottomAnchor, constant: 10),
            songPriceBG.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            songPriceBG.trailingAnchor.constraint(equalTo: songPrice.trailingAnchor, constant: 10),
            songPriceBG.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            songPrice.topAnchor.constraint(equalTo: songPriceBG.topAnchor, constant: 5),
            songPrice.leadingAnchor.constraint(equalTo: songPriceBG.leadingAnchor, constant: 10),
            songPrice.trailingAnchor.constraint(equalTo: songPriceBG.trailingAnchor, constant: -10),
            songPrice.bottomAnchor.constraint(equalTo: songPriceBG.bottomAnchor, constant: -5),
        ])
    }
}
