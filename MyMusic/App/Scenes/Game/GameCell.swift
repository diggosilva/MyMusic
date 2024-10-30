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
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var gameTotalPrice: UILabel = {
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
    
    func configure(game: Game) {
        gameName.text = game.title
        self.accessoryType = .disclosureIndicator
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy () {
        addSubview(gameName)
        addSubview(gameTotalPrice)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            gameName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            gameName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            gameName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            gameTotalPrice.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 10),
            gameTotalPrice.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            gameTotalPrice.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            gameTotalPrice.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
