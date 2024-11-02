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
        longPressRecognizer()
    }
    
    private func longPressRecognizer() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        songView.tableview.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc private func handleLongPress(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let location = gestureRecognizer.location(in: songView.tableview)
            if let indexPath = songView.tableview.indexPathForRow(at: location) {
                let song = viewModel.cellForRowAt(indexPath: indexPath)
                self.editSongAlert(song: song, indexPath: indexPath)
            }
        }
    }
    
    private func editSongAlert(song: Song, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Editar música", message: "Atualize o nome e o valor da música.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = song.title
            textField.configTextField(textField: textField, placeholder: "Nome da música")
        }
        
        alert.addTextField { textField in
            textField.text = "\(song.price)"
            textField.configTextField(textField: textField, placeholder: "Valor da música", keyboardType: .decimalPad)
        }
        
        let saveAction = UIAlertAction(title: "Salvar", style: .default) { action in
            if let updatedSongTitle = alert.textFields?.first?.text, !updatedSongTitle.isEmpty,
               let updatedSongPriceText = alert.textFields?.last?.text, !updatedSongPriceText.isEmpty,
               let updatedSongPrice = Double(updatedSongPriceText) {
                self.viewModel.updateSong(at: indexPath.row, newSongTitle: updatedSongTitle, newPrice: updatedSongPrice)
                self.updateTableViewSmoothlyForUpdateSong(at: indexPath)
            }
        }
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true)
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
            textField.configTextField(textField: textField, placeholder: "Nome da música")
        }
        
        alert.addTextField { textField in
            textField.configTextField(textField: textField, placeholder: "Valor da música", keyboardType: .decimalPad)
        }
        
        let addAction = UIAlertAction(title: "Adicionar", style: .default) { action in
            if let songTitle = alert.textFields?.first?.text, !songTitle.isEmpty,
               let songPrice = alert.textFields?.last?.text, !songPrice.isEmpty {
                self.viewModel.addSong(songTitle: songTitle, songPrice: songPrice)
                self.updateTableViewSmoothlyForNewSong()
            }
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func updateTableViewSmoothlyForNewSong() {
        // Obter o índice do novo cliente
        let indexPath = IndexPath(row: viewModel.numberOfRowsInSection() - 1, section: 0)
        
        // Atualizar a tabela de forma suave
        songView.tableview.beginUpdates()
        songView.tableview.insertRows(at: [indexPath], with: .automatic)
        songView.tableview.endUpdates()
    }
    
    func updateTableViewSmoothlyForUpdateSong(at indexPath: IndexPath) {
        songView.tableview.beginUpdates()
        songView.tableview.reloadRows(at: [indexPath], with: .automatic)
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
