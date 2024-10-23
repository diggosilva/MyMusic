//
//  GameCell.swift
//  MyMusic
//
//  Created by Diggo Silva on 23/10/24.
//

import UIKit

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
