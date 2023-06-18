//
//  MatchInfoTableViewCell.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 13.06.2023.
//

import UIKit
 
final class MatchInfoTableViewCell: UITableViewCell {
    private let heroImageView = UIImageView()
    private let playerNameLabel = UILabel()
    private let kdaLabel = UILabel()
    private let goldLabel = UILabel()
    private let itemOneImageView = UIImageView()
    private let itemTwoImageView = UIImageView()
    private let itemThreeImageView = UIImageView()
    private let itemFourImageView = UIImageView()
    private let itemFiveImageView = UIImageView()
    private let itemSixImageView = UIImageView()
    
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
        
        playerNameLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.mediumFontSize))
        contentView.addSubview(playerNameLabel)
        
        kdaLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.smallFontSize))
        contentView.addSubview(kdaLabel)
        
        goldLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.smallFontSize))
        contentView.addSubview(goldLabel)
        
        itemOneImageView.contentMode = .scaleToFill
        itemOneImageView.backgroundColor = .gray
        contentView.addSubview(itemOneImageView)
        
        itemTwoImageView.contentMode = .scaleToFill
        itemTwoImageView.backgroundColor = .gray
        contentView.addSubview(itemTwoImageView)
        
        itemThreeImageView.contentMode = .scaleToFill
        itemThreeImageView.backgroundColor = .gray
        contentView.addSubview(itemThreeImageView)
        
        itemFourImageView.contentMode = .scaleToFill
        itemFourImageView.backgroundColor = .gray
        contentView.addSubview(itemFourImageView)
        
        itemFiveImageView.contentMode = .scaleToFill
        itemFiveImageView.backgroundColor = .gray
        contentView.addSubview(itemFiveImageView)
        
        itemSixImageView.contentMode = .scaleToFill
        itemSixImageView.backgroundColor = .gray
        contentView.addSubview(itemSixImageView)
    }
    
    private func setConstraints() {
        heroImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CGFloat(Constants.mediumConstraintOffset))
            make.bottom.equalToSuperview().inset(CGFloat(Constants.mediumConstraintOffset))
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        kdaLabel.snp.makeConstraints { make in
            make.bottom.equalTo(heroImageView.snp.bottom)
            make.leading.equalTo(heroImageView.snp.trailing).offset(CGFloat(Constants.mediumConstraintOffset))
        }
        
        playerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(heroImageView.snp.top)
            make.leading.equalTo(heroImageView.snp.trailing).offset(CGFloat(Constants.mediumConstraintOffset))
            make.width.equalTo(180)
        }
        
        goldLabel.snp.makeConstraints { make in
            make.bottom.equalTo(heroImageView.snp.bottom)
            make.leading.equalTo(kdaLabel.snp.trailing).offset(CGFloat(Constants.mediumConstraintOffset))
        }
        
        itemOneImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(85)
            make.height.equalTo(CGFloat(Constants.itemImageHeight))
            make.width.equalTo(CGFloat(Constants.itemImageWidth))
        }

        itemTwoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(45)
            make.height.equalTo(CGFloat(Constants.itemImageHeight))
            make.width.equalTo(CGFloat(Constants.itemImageWidth))
        }

        itemThreeImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().inset(CGFloat(Constants.mediumConstraintOffset))
            make.height.equalTo(CGFloat(Constants.itemImageHeight))
            make.width.equalTo(CGFloat(Constants.itemImageWidth))
        }

        itemFourImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(CGFloat(Constants.mediumConstraintOffset))
            make.trailing.equalToSuperview().inset(85)
            make.height.equalTo(CGFloat(Constants.itemImageHeight))
            make.width.equalTo(CGFloat(Constants.itemImageWidth))
        }
        
        itemFiveImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(CGFloat(Constants.mediumConstraintOffset))
            make.trailing.equalToSuperview().inset(45)
            make.height.equalTo(CGFloat(Constants.itemImageHeight))
            make.width.equalTo(CGFloat(Constants.itemImageWidth))
        }
        
        itemSixImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(CGFloat(Constants.mediumConstraintOffset))
            make.trailing.equalToSuperview().inset(CGFloat(Constants.mediumConstraintOffset))
            make.height.equalTo(CGFloat(Constants.itemImageHeight))
            make.width.equalTo(CGFloat(Constants.itemImageWidth))
        }
    }
    
    func configure(heroImagePath: String, playerName: String, kills: Int, deaths: Int, assists: Int, gold: Int, imagesPath: [String]) {
        let urlImage = "https://cdn.cloudflare.steamstatic.com/" + "\(heroImagePath)"
        NetworkManager.shared.fetchImage(from: urlImage) { imageData in
            self.heroImageView.image = UIImage(data:  imageData)
        }
        
        playerNameLabel.text = playerName
        kdaLabel.text = "\(kills)/\(deaths)/\(assists)"
        goldLabel.text = "Золото: \(gold)"
        
        let itemImageViews: [UIImageView] = [itemOneImageView, itemTwoImageView,itemThreeImageView, itemFourImageView, itemFiveImageView, itemSixImageView]
        for (index, path) in imagesPath.enumerated() {
            let urlImage = "https://cdn.cloudflare.steamstatic.com/" + "\(path)"
            NetworkManager.shared.fetchImage(from: urlImage) { imageData in
                itemImageViews[index].image = UIImage(data: imageData)
            }
        }
    }
}
