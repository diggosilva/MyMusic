//
//  FeedViewController.swift
//  MyMusic
//
//  Created by Diggo Silva on 20/10/24.
//

import UIKit

class FeedViewController: UIViewController {
    
    let feedView = FeedView()
    let viewModel = FeedViewModel()
    
    override func loadView() {
        super.loadView()
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSources()
    }
    
    private func setNavBar() {
        title = "Clientes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector (addButtonTapped))
    }
    
    private func setDelegatesAndDataSources() {
        feedView.tableView.delegate = self
        feedView.tableView.dataSource = self
    }
    
    @objc private func addButtonTapped() {
        print("Cliente adicionado")
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else { return UITableViewCell() }
        cell.textLabel?.text = "Cliente \(indexPath.row)"
        return cell
    }
}

class FeedCell: UITableViewCell {
    static let identifier: String = "FeedCell"
    
    lazy var clientName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .preferredFont(forTextStyle: .subheadline)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        addSubview(clientName)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            clientName.centerYAnchor.constraint(equalTo: centerYAnchor),
            clientName.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            clientName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            clientName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            clientName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
        ])
    }
}

class Client {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

protocol FeedViewModelProtocol {
    func numberOfRowsInSection() -> Int
    func cellForRowAt(indexPath: IndexPath) -> Client
}

class FeedViewModel: FeedViewModelProtocol {
    let listClient: [Client] = []
    
    func numberOfRowsInSection() -> Int {
        return listClient.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Client {
        return listClient[indexPath.row]
    }
}
