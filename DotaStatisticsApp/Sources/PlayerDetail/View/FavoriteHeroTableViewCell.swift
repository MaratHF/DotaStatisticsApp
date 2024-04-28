//
//  FavoriteHeroTableViewCell.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 10.06.2023.
//

import UIKit

final class FavoriteHeroTableViewCell: UITableViewCell {
    private var heroImageView = UIImageView()
    private var heroNameLabel = UILabel()
    private var lastPlayedLabel = UILabel()
    private var picksLabel = UILabel()
    private var winsLabel = UILabel()
    
    private var headerOne = UILabel()
    private var headerTwo = UILabel()
    private var headerThree = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellHeaders() {
        heroImageView.isHidden = true
        heroNameLabel.isHidden = true
        lastPlayedLabel.isHidden = true
        picksLabel.isHidden = true
        winsLabel.isHidden = true
        
        headerOne.isHidden = false
        headerTwo.isHidden = false
        headerThree.isHidden = false
    }
    
    func configure(imagePath path: String, heroName: String, lastPlayed: Int, wins: Int, picks: Int) {
        let url = "https://cdn.cloudflare.steamstatic.com" + path
        NetworkManager.shared.fetchImage(from: url) { [weak self] imageData in
            self?.heroImageView.image = UIImage(data: imageData)
        }
        heroNameLabel.text = heroName
        picksLabel.text = "\(picks)"
        winsLabel.text = "\(wins)"
        let timeInterval = Date().timeIntervalSince1970 - TimeInterval(lastPlayed)
        let hours = Int(timeInterval / 3600)
        let days = Int(hours / 24)
        let months = Int(days / 30)
        let years = Int(months / 12)
        
        if years >= 1 {
            lastPlayedLabel.text = """
\(years) год назад
"""
        } else if months >= 1 {
            lastPlayedLabel.text = """
\(months) месяцев назад
"""
        } else if days >= 1 {
            lastPlayedLabel.text = """
\(days) дней назад
"""
        } else {
            lastPlayedLabel.text = """
\(hours) часов назад
"""
        }
    }
    
    private func setupSubviews() {
        heroImageView.contentMode = .scaleToFill
        heroImageView.clipsToBounds = true
        heroImageView.layer.cornerRadius = CGFloat(Constants.imageCornerRadius)
        heroImageView.backgroundColor = .gray
        contentView.addSubview(heroImageView)
        
        heroNameLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.largeFontSize))
        contentView.addSubview(heroNameLabel)
        
        lastPlayedLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.smallFontSize))
        lastPlayedLabel.numberOfLines = 0
        contentView.addSubview(lastPlayedLabel)
        
        picksLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.largeFontSize))
        contentView.addSubview(picksLabel)
        
        winsLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.largeFontSize))
        contentView.addSubview(winsLabel)
        
        headerOne.text = "Герои"
        headerOne.isHidden = true
        contentView.addSubview(headerOne)
        
        headerTwo.text = "Игр"
        headerTwo.isHidden = true
        contentView.addSubview(headerTwo)
        
        headerThree.text = "Побед"
        headerThree.isHidden = true
        contentView.addSubview(headerThree)
    }
    
    private func setConstraints() {
        heroImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CGFloat(Constants.mediumConstraintOffset))
            make.centerY.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        headerOne.snp.makeConstraints { make in
            make.leading.equalTo(heroImageView.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        heroNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(heroImageView.snp.trailing).offset(CGFloat(Constants.bigConstraintOffset))
            make.top.equalToSuperview().offset(10)
        }
        
        lastPlayedLabel.snp.makeConstraints { make in
            make.leading.equalTo(heroImageView.snp.trailing).offset(CGFloat(Constants.bigConstraintOffset))
            make.top.equalTo(heroNameLabel.snp.bottom).offset(5)
        }
        
        picksLabel.snp.makeConstraints { make in
            make.leading.equalTo(heroImageView.snp.trailing).offset(210)
            make.centerY.equalToSuperview()
        }
        
        headerTwo.snp.makeConstraints { make in
            make.leading.equalTo(picksLabel.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        winsLabel.snp.makeConstraints { make in
            make.leading.equalTo(heroImageView.snp.trailing).offset(280)
            make.centerY.equalToSuperview()
        }
        
        headerThree.snp.makeConstraints { make in
            make.leading.equalTo(winsLabel.snp.leading)
            make.centerY.equalToSuperview()
        }
    }
}
