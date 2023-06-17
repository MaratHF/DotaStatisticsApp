//
//  PlayersTableViewCell.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 10.06.2023.
//

import UIKit
import SnapKit

class PlayersTableViewCell: UITableViewCell {
    
    private var playerImageView = UIImageView()
    private var nameLabel = UILabel()
    private var idLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        playerImageView.contentMode = .scaleAspectFit
        playerImageView.clipsToBounds = true
        playerImageView.layer.cornerRadius = 10
        playerImageView.backgroundColor = .gray
        contentView.addSubview(playerImageView)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        contentView.addSubview(nameLabel)
        
        idLabel.font = UIFont.systemFont(ofSize: 18)
        contentView.addSubview(idLabel)
    }
    
    private func setConstraints() {
        playerImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(playerImageView.snp.trailing).offset(10)
            make.top.trailing.equalToSuperview().offset(5)
            
        }
        
        idLabel.snp.makeConstraints { make in
            make.leading.equalTo(playerImageView.snp.trailing).offset(10)
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.trailing.equalToSuperview().offset(5)
        }
    }
    
    func configure(with profile: Profile) {
        NetworkManager.shared.fetchImage(from: profile.avatarfull) { imageData in
            let image = UIImage(data: imageData)
            self.playerImageView.image = image
        }
        nameLabel.text = profile.personaname
        idLabel.text = String(profile.account_id)
    }
}
