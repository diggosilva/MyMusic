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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        let gameVC = GameViewController(client: client)
        gameVC.title = "Jogos - \(client.name)"
        navigationController?.pushViewController(gameVC, animated: true)
    }
}
