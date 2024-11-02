//
//  SongViewController.swift
//  MyMusic
//
//  Created by Diggo Silva on 30/10/24.
//

import UIKit

class SongViewController: UIViewController {
    let songView = SongView()
    let viewModel: SongViewModelProtocol
    
    init(game: Game, client: Client) {
        self.viewModel = SongViewModel(game: game, client: client)
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
                self.updateTableViewSmoothly()
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func updateTableViewSmoothly() {
        // Obter o índice do novo cliente
        let indexPath = IndexPath(row: viewModel.numberOfRowsInSection() - 1, section: 0)
        
        // Atualizar a tabela de forma suave
        songView.tableview.beginUpdates()
        songView.tableview.insertRows(at: [indexPath], with: .automatic)
        songView.tableview.endUpdates()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //TODO: Implementar o metodo delegate pra deletar célula
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "", message: "Isso apagará permanentemente a música selecionada. Esta ação não pode ser desfeita.", preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Apagar Deste iPhone", style: .destructive) { action in
                let song = self.viewModel.cellForRowAt(indexPath: indexPath)
                self.viewModel.removeSong(song: song)
                self.songView.tableview.deleteRows(at: [indexPath], with: .automatic)
            }
            alert.addAction(deleteAction)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
}
