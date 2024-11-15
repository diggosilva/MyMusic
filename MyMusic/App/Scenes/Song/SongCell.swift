//
//  SongCell.swift
//  MyMusic
//
//  Created by Diggo Silva on 30/10/24.
//

import UIKit

class SongCell: UITableViewCell {
    static let identifier: String = "SongCell"
    
    lazy var songName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .preferredFont(forTextStyle: .headline)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var songPrice: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .preferredFont(forTextStyle: .subheadline)
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
        songPrice.text = String(format: "$ %.2f", song.price)
    }
    
    private func setupView() {
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy () {
        addSubviews([songName, songPriceBG, songPrice])
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            songName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            songName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            songName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            songPriceBG.topAnchor.constraint(equalTo: songName.bottomAnchor, constant: 5),
            songPriceBG.leadingAnchor.constraint(equalTo: songName.leadingAnchor),
            songPriceBG.trailingAnchor.constraint(equalTo: songPrice.trailingAnchor, constant: 10),
            songPriceBG.heightAnchor.constraint(equalToConstant: 28),
            songPriceBG.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            songPrice.topAnchor.constraint(equalTo: songPriceBG.topAnchor, constant: 5),
            songPrice.leadingAnchor.constraint(equalTo: songPriceBG.leadingAnchor, constant: 10),
            songPrice.trailingAnchor.constraint(equalTo: songPriceBG.trailingAnchor, constant: -10),
            songPrice.bottomAnchor.constraint(equalTo: songPriceBG.bottomAnchor, constant: -5),
        ])
    }
}
