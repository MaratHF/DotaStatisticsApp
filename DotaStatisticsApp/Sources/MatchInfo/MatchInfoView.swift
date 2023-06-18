//
//  MatchInfoView.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 13.06.2023.
//

import UIKit
import SnapKit

protocol MatchInfoViewProtocol: AnyObject {
    func set(match: Match)
    func set(itemsById: [String : String])
    func set(itemsByName: [String : Item])
    func errorDownloadData()
}

final class MatchInfoView: UIView {
    var gameModes: [String : String] = [:]
    var heroes: [Hero] = []
    var showAlert: (() -> Void)?
    
    private var dataCount = 0 {
        didSet {
            if dataCount == 3 {
                stopActivityIndicator()
            }
        }
    }
    private var match: Match? {
        didSet {
            tableView.reloadData()
            setGeneralInfo()
            dataCount += 1
        }
    }
    private var itemsById: [String : String] = [:] {
        didSet{
            tableView.reloadData()
            dataCount += 1
        }
    }
    private var itemsByName: [String : Item] = [:] {
        didSet {
            tableView.reloadData()
            dataCount += 1
        }
    }
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let generalInfoView = UIView()
    private let gameModeLabel = UILabel()
    private let scoreLabel = UILabel()
    private let radiantLabel = UILabel()
    private let direLabel = UILabel()
    private let radiantResultLabel = UILabel()
    private let direResultLabel = UILabel()
    private let durationLabel = UILabel()
    private lazy var tableView = makeTableView()
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
        setConstraints()
        startActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods
private extension MatchInfoView {
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(MatchInfoTableViewCell.self, forCellReuseIdentifier: MatchInfoTableViewCell.description())
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = CGFloat(Constants.bigCellHeight)
        return tableView
    }
    
    func setupSubviews() {
        self.backgroundColor = .systemBackground
        
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        
        generalInfoView.backgroundColor = .systemBackground
        self.addSubview(generalInfoView)
        
        generalInfoView.addSubview(gameModeLabel)
        generalInfoView.addSubview(scoreLabel)
        generalInfoView.addSubview(radiantLabel)
        generalInfoView.addSubview(direLabel)
        generalInfoView.addSubview(radiantResultLabel)
        generalInfoView.addSubview(direResultLabel)
        generalInfoView.addSubview(durationLabel)
        
        tableView.backgroundColor = .systemBackground
        self.addSubview(tableView)
    }
    
    func setConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        generalInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.size.height * CGFloat(Constants.subviewOffsetMultiplier))
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        
        gameModeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(gameModeLabel.snp.bottom).offset(CGFloat(Constants.mediumConstraintOffset))
            make.centerX.equalToSuperview()
        }
        
        radiantLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.top)
            make.trailing.equalTo(self.snp.centerX).offset(-55)
        }
        
        radiantResultLabel.snp.makeConstraints { make in
            make.top.equalTo(radiantLabel.snp.bottom).offset(CGFloat(Constants.smallConstraintOffset))
            make.centerX.equalTo(radiantLabel.snp.centerX)
        }
        
        direLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.top)
            make.leading.equalTo(self.snp.centerX).offset(55)
        }
        
        direResultLabel.snp.makeConstraints { make in
            make.top.equalTo(direLabel.snp.bottom).offset(CGFloat(Constants.smallConstraintOffset))
            make.centerX.equalTo(direLabel.snp.centerX)
        }
        
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreLabel.snp.bottom).offset(CGFloat(Constants.largeConstraintOffset))
            make.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(generalInfoView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
        generalInfoView.isHidden = true
        tableView.isHidden = true
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.activityIndicator.startAnimating()
            self.generalInfoView.isHidden = false
            self.tableView.isHidden = false
        }
    }
    
    func setGeneralInfo() {
        if let match = match {
            for (key, value) in gameModes {
                if key == "\(match.game_mode)" {
                    gameModeLabel.text = value
                }
            }
            gameModeLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.headerFontSize))
            
            scoreLabel.text = "\(match.radiant_score) : \(match.dire_score)"
            scoreLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(Constants.headerFontSize))
            
            radiantLabel.text = "Свет"
            radiantLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.headerFontSize))
            
            direLabel.text = "Тьма"
            direLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.headerFontSize))
            
            radiantResultLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.smallFontSize))
            direResultLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.smallFontSize))
            if match.radiant_win {
                radiantResultLabel.text = "Победа"
                radiantResultLabel.textColor = .green
                direResultLabel.text = "Поражение"
                direResultLabel.textColor = .red
            } else {
                radiantResultLabel.text = "Поражение"
                radiantResultLabel.textColor = .red
                direResultLabel.text = "Победа"
                direResultLabel.textColor = .green
            }
            
            let minutes = match.duration / 60
            let seconds = match.duration % 60
            var stringMin = "\(minutes)"
            var stringSec = "\(seconds)"
            if "\(minutes)".count == 1 {
                stringMin = "0\(minutes)"
            }
            if "\(seconds)".count == 1 {
                stringSec = "0\(seconds)"
            }
            durationLabel.text = "Длительность: \(stringMin):\(stringSec)"
            durationLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.mediumFontSize))
        }
    }
}
//MARK: - Table view data source
extension MatchInfoView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MatchInfoTableViewCell.description(), for: indexPath)
                as? MatchInfoTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        var filteredPlayers = match?.players
        
        if indexPath.section == 0 {
            filteredPlayers = filteredPlayers?.filter({ $0.isRadiant })
        } else {
            filteredPlayers = filteredPlayers?.filter({ !$0.isRadiant })
        }
        
        if let player = filteredPlayers?[indexPath.row] {
            let items = [player.item_0, player.item_1, player.item_2, player.item_3, player.item_4, player.item_5]
            let hero = heroes.filter({ $0.id == player.hero_id }).last
            var names: [String] = []
            var images: [String] = []
            for item in itemsById {
                for i in items {
                    if item.key == "\(i)" {
                        names.append(item.value)
                    }
                }
            }
            for item in itemsByName {
                for name in names {
                    if item.key == name {
                        images.append(item.value.img)
                    }
                }
            }
            cell.configure(
                heroImagePath: hero?.img ?? "",
                playerName: player.personaname ?? "player name",
                kills: player.kills,
                deaths: player.deaths,
                assists: player.assists,
                gold: player.total_gold,
                imagesPath: images
            )
        }
        
        return cell
    }
}
//MARK: - Table view delegate
extension MatchInfoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Силы света"
        } else {
            return "Силы тьмы"
        }
    }
}

extension MatchInfoView: MatchInfoViewProtocol {
    func set(match: Match) {
        self.match = match
    }
    
    func set(itemsById: [String : String]) {
        self.itemsById = itemsById
    }
    
    func set(itemsByName: [String : Item]) {
        self.itemsByName = itemsByName
    }
    
    func errorDownloadData() {
        DispatchQueue.global().async { [ weak self] in
            guard let self = self else { return }
            self.dataCount = 0
            self.stopActivityIndicator()
            DispatchQueue.main.async {
                self.startActivityIndicator()
                self.showAlert?()
            }
        }
    }
}
