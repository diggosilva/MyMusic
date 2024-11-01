//
//  FeedCell.swift
//  MyMusic
//
//  Created by Diggo Silva on 21/10/24.
//

import UIKit

class FeedCell: UITableViewCell {
    static let identifier: String = "FeedCell"
    
    lazy var clientName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .preferredFont(forTextStyle: .headline)
        return lbl
    }()
    
    lazy var clientTotalGame: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .preferredFont(forTextStyle: .subheadline)
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(client: Client) {
        clientName.text = client.name
        
        if client.games.isEmpty {
            clientTotalGame.text = "Nenhum jogo ainda"
        } else if client.games.count == 1 {
            clientTotalGame.text = "\(client.games.count) jogo"
        } else {
            clientTotalGame.text = "\(client.games.count) jogos"
        }
        self.accessoryType = .disclosureIndicator
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy () {
        addSubview(clientName)
        addSubview(clientTotalGame)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            clientName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            clientName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            clientName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            clientTotalGame.topAnchor.constraint(equalTo: clientName.bottomAnchor, constant: 10),
            clientTotalGame.leadingAnchor.constraint(equalTo: clientName.leadingAnchor),
            clientTotalGame.trailingAnchor.constraint(equalTo: clientName.trailingAnchor),
            clientTotalGame.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
}
