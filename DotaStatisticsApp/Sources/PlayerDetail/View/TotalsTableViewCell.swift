//
//  TotalsTableViewCell.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 12.06.2023.
//

import UIKit

final class TotalsTableViewCell: UITableViewCell {
    private var starsImageView = UIImageView()
    private var rankImageView = UIImageView()
    private var matchesCountLabel = UILabel()
    private var winRateLabel = UILabel()
    private var kdaLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        starsImageView.contentMode = .scaleToFill
        starsImageView.clipsToBounds = true
        contentView.addSubview(starsImageView)
        
        rankImageView.contentMode = .scaleToFill
        rankImageView.clipsToBounds = true
        contentView.addSubview(rankImageView)
        
        matchesCountLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.largeFontSize))
        matchesCountLabel.numberOfLines = 2
        matchesCountLabel.textAlignment = .center
        contentView.addSubview(matchesCountLabel)
        
        winRateLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.largeFontSize))
        winRateLabel.numberOfLines = 2
        winRateLabel.textAlignment = .center
        contentView.addSubview(winRateLabel)
        
        kdaLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.largeFontSize))
        kdaLabel.numberOfLines = 2
        kdaLabel.textAlignment = .center
        contentView.addSubview(kdaLabel)
    }
    
    private func setConstraints() {
        starsImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CGFloat(Constants.bigConstraintOffset))
            make.centerY.equalToSuperview()
            make.width.equalTo(65)
            make.height.equalTo(65)
        }
        
        rankImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CGFloat(Constants.bigConstraintOffset))
            make.centerY.equalToSuperview()
            make.width.equalTo(65)
            make.height.equalTo(65)
        }
        
        matchesCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(rankImageView.snp.trailing).offset(CGFloat(Constants.hugeConstraintOffset))
            make.centerY.equalToSuperview()
        }
        
        winRateLabel.snp.makeConstraints { make in
            make.leading.equalTo(matchesCountLabel.snp.trailing).offset(CGFloat(Constants.hugeConstraintOffset))
            make.centerY.equalToSuperview()
        }
        
        kdaLabel.snp.makeConstraints { make in
            make.leading.equalTo(winRateLabel.snp.trailing).offset(CGFloat(Constants.hugeConstraintOffset))
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(withSummary summary: Summary) {
        let rank = "\(summary.rankTier ?? 0)"

        NetworkManager.shared.fetchImage(from: "https://www.opendota.com/assets/images/dota2/rank_icons/rank_icon_\(rank.first ?? "0").png") { [weak self] imageData in
            self?.rankImageView.image = UIImage(data: imageData)
        }
        
        if let starsCount = rank.last {
            NetworkManager.shared.fetchImage(from: "https://www.opendota.com/assets/images/dota2/rank_icons/rank_star_\(starsCount).png") { [weak self] starsData in
                self?.starsImageView.image = UIImage(data: starsData)
            }
        }
        
        if let matchesCount = summary.matchesCount {
            matchesCountLabel.text = """
\(matchesCount)
матчей
"""
        }
        let win = summary.winLose?.win ?? 0
        let lose = summary.winLose?.lose ?? 0
        let winRate = (round((Double(win) / Double(win + lose)) * 10000) / 100)
        winRateLabel.text = """
\(winRate)%
побед
"""
        let kills = summary.playerTotals?.filter({ $0.field == "kills" }).last?.sum ?? 0
        let deaths = summary.playerTotals?.filter({ $0.field == "deaths" }).last?.sum ?? 1
        let assists = summary.playerTotals?.filter({ $0.field == "assists" }).last?.sum ?? 0
        let kda = round(((kills + assists) /  deaths) * 100) / 100
        kdaLabel.text = """
\(kda)
KDA
"""
    }
}


