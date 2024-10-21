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