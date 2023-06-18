//
//  MatchesTableViewCell.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 10.06.2023.
//

import UIKit
import SnapKit

final class MatchesTableViewCell: UITableViewCell {
    var fetchImage: (() -> Void)?
    private var heroImageView = UIImageView()
    private var winLoseImageView = UIImageView()
    private var gameModeLabel = UILabel()
    private var playedTimeLabel = UILabel()
    private var kdaLabel = UILabel()
    
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
    
    private func setupSubviews() {
        heroImageView.contentMode = .scaleToFill
        heroImageView.clipsToBounds = true
        heroImageView.layer.cornerRadius = CGFloat(Constants.imageCornerRadius)
        heroImageView.backgroundColor = .gray
        contentView.addSubview(heroImageView)
        
        winLoseImageView.contentMode = .scaleAspectFit
        winLoseImageView.layer.cornerRadius = 2
        contentView.addSubview(winLoseImageView)
        
        gameModeLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.largeFontSize))
        contentView.addSubview(gameModeLabel)
        
        playedTimeLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.smallFontSize))
        contentView.addSubview(playedTimeLabel)
        
        kdaLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.largeFontSize))
        kdaLabel.textAlignment = .center
        contentView.addSubview(kdaLabel)
        
        headerOne.text = "Герои"
        headerOne.isHidden = true
        contentView.addSubview(headerOne)
        
        headerTwo.text = "Краткое описание"
        headerTwo.isHidden = true
        contentView.addSubview(headerTwo)
        
        headerThree.text = "KDA"
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
        
        winLoseImageView.snp.makeConstraints { make in
            make.leading.equalTo(heroImageView.snp.trailing).offset(CGFloat(Constants.bigConstraintOffset))
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
        }
        
        headerTwo.snp.makeConstraints { make in
            make.leading.equalTo(winLoseImageView.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        gameModeLabel.snp.makeConstraints { make in
            make.leading.equalTo(winLoseImageView.snp.trailing).offset(CGFloat(Constants.largeConstraintOffset))
            make.top.equalTo(heroImageView.snp.top)
        }
        
        playedTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(winLoseImageView.snp.trailing).offset(CGFloat(Constants.largeConstraintOffset))
            make.bottom.equalTo(heroImageView.snp.bottom)
        }
        
        kdaLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.trailing).inset(140)
            make.centerY.equalToSuperview()
        }
        
        headerThree.snp.makeConstraints { make in
            make.leading.equalTo(kdaLabel.snp.leading)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCellHeaders() {
        heroImageView.isHidden = true
        gameModeLabel.isHidden = true
        playedTimeLabel.isHidden = true
        winLoseImageView.isHidden = true
        kdaLabel.isHidden = true
        
        headerOne.isHidden = false
        headerTwo.isHidden = false
        headerThree.isHidden = false
    }
    
    func configure(imagePath path: String, isWin: Bool, gameMode: String, kills: Int, deaths: Int, assists: Int, playedTime: Int) {
        let url = "https://cdn.cloudflare.steamstatic.com" + path
        NetworkManager.shared.fetchImage(from: url) {[weak self] imageData in
            self?.heroImageView.image = UIImage(data: imageData) ?? UIImage(named: "win")
        }
        gameModeLabel.text = gameMode
        winLoseImageView.image = isWin ? UIImage(named: "win") : UIImage(named: "lose")
        kdaLabel.text = """
\(kills) / \(deaths) / \(assists)
"""
        let timeInterval = Date().timeIntervalSince1970 - TimeInterval(playedTime)
        let hours = Int(timeInterval / 3600)
        let days = Int(hours / 24)
        let months = Int(days / 30)
        let years = Int(months / 12)
        
        if years >= 1 {
            playedTimeLabel.text = """
\(years) год назад
"""
        } else if months >= 1 {
            playedTimeLabel.text = """
\(months) месяцев назад
"""
        } else if days >= 1 {
            playedTimeLabel.text = """
\(days) дней назад
"""
        } else {
            playedTimeLabel.text = """
\(hours) часов назад
"""
        }
    }
}
