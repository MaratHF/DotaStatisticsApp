//
//  PlayersTableViewCell.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 10.06.2023.
//

import UIKit
import SnapKit

final class PlayersTableViewCell: UITableViewCell {
    
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
        playerImageView.layer.cornerRadius = CGFloat(Constants.imageCornerRadius)
        playerImageView.backgroundColor = .gray
        contentView.addSubview(playerImageView)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(Constants.largeFontSize))
        contentView.addSubview(nameLabel)
        
        idLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.mediumFontSize))
        contentView.addSubview(idLabel)
    }
    
    private func setConstraints() {
        playerImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CGFloat(Constants.smallConstraintOffset))
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(playerImageView.snp.trailing).offset(CGFloat(Constants.mediumConstraintOffset))
            make.top.trailing.equalToSuperview().offset(CGFloat(Constants.smallConstraintOffset))
            
        }
        
        idLabel.snp.makeConstraints { make in
            make.leading.equalTo(playerImageView.snp.trailing).offset(CGFloat(Constants.mediumConstraintOffset))
            make.top.equalTo(nameLabel.snp.bottom).offset(CGFloat(Constants.smallConstraintOffset))
            make.trailing.equalToSuperview().offset(CGFloat(Constants.smallConstraintOffset))
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
