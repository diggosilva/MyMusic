//
//  FeedViewController.swift
//  MyMusic
//
//  Created by Diggo Silva on 20/10/24.
//

import UIKit

class FeedViewController: UIViewController {
    let feedView = DefaultView()
    lazy var viewModel: FeedViewModelProtocol = FeedViewModel()
    
    override func loadView() {
        super.loadView()
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setDelegatesAndDataSources()
        registerCells()
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
    
    private func registerCells() {
        feedView.registerCell(cellType: FeedCell.self, identifier: FeedCell.identifier)
    }
    
    private func loadClients() {
        viewModel.loadClient()
        feedView.tableView.reloadData()
    }
    
    @objc func addClientAlert() {
        let alert = UIAlertController(title: "Adicionar Cliente", message: "Insira o nome do cliente", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.configTextField(textField: textField, placeholder: "Nome do cliente")
        }
        
        let addAction = UIAlertAction(title: "Adicionar", style: .default) { action in
            if let clientName = alert.textFields?.first?.text, !clientName.isEmpty {
                // Adiciona o cliente na lista
                self.viewModel.addClient(clientName: clientName)
                self.updateTableViewSmoothlyForNewClient()
            }
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func updateTableViewSmoothlyForNewClient() {
        // Obter o índice do novo cliente
        let indexPath = IndexPath(row: viewModel.numberOfRowsInSection() - 1, section: 0)
        
        // Atualizar a tabela de forma suave
        feedView.tableView.beginUpdates()
        feedView.tableView.insertRows(at: [indexPath], with: .automatic)
        feedView.tableView.endUpdates()
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "", message: "Isso apagará permanentemente o cliente selecionado. Esta ação não pode ser desfeita.", preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Apagar Deste iPhone", style: .destructive) { action in
                let client = self.viewModel.cellForRowAt(indexPath: indexPath)
                self.viewModel.removeClient(client: client)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            alert.addAction(deleteAction)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
}
