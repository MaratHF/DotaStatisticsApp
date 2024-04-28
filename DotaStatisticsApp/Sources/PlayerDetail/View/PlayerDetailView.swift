//
//  PlayerDetailView.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 10.06.2023.
//

import UIKit

protocol PlayerDetailViewProtocol: AnyObject {
    func set(player: Player)
    func setMatches(with matches: [PlayerMatch])
    func setFavoriteHeroes(with heroes: [PlayersHero])
    func set(summary: Summary)
    func set(gameModes: [String : String])
    func set(heroes: [Hero])
    func set(favoritePlayers: [FavoritePlayer])
    func errorDownloadData()
}

final class PlayerDetailView: UIView {
    var favoriteButton = UIButton()
    var deleteFavoritePlayer: ((FavoritePlayer) -> Void)?
    var createFavoritePlayer: ((Profile) -> Void)?
    var matchCellTapped: (([Hero], [String : String], Int) -> Void)?
    var showAllElements: (([Hero], [String : String], [PlayerMatch], [PlayersHero]) -> Void)?
    var showAlert: (() -> Void)?
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let profileView = UIView()
    private let avatarImageView = UIImageView()
    private let nickNameLabel = UILabel()
    private let accountIdLabel = UILabel()
    private lazy var tableView = makeTableView()
    private var favoritePlayers: [FavoritePlayer] = [] 
    private var dataCount = 0 {
        didSet {
            if dataCount == 6 {
                stopActivityIndicator()
            }
        }
    }
    private var gameModes: [String : String] = [:] {
        didSet {
            dataCount += 1
        }
    }
    private var heroes: [Hero] = [] {
        didSet {
            dataCount += 1
        }
    }
    private var player: Player? {
        didSet {
            if let player = player {
                setPlayerProfile(player: player)
                dataCount += 1
            }
        }
    }
    private var matches: [PlayerMatch] = [] {
        didSet {
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
            dataCount += 1
        }
    }
    
    private var favoriteHeroes: [PlayersHero] = [] {
        didSet {
            tableView.reloadSections(IndexSet(integer: 2), with: .none)
            dataCount += 1
        }
    }
    private var summary: Summary? {
        didSet {
            tableView.reloadSections(IndexSet(integer: 0), with: .none)
            dataCount += 1
        }
    }
    
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
private extension PlayerDetailView {
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(TotalsTableViewCell.self, forCellReuseIdentifier: TotalsTableViewCell.description())
        tableView.register(MatchesTableViewCell.self, forCellReuseIdentifier: MatchesTableViewCell.description())
        tableView.register(FavoriteHeroTableViewCell.self, forCellReuseIdentifier: FavoriteHeroTableViewCell.description())
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.description())
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }
    
    func setupSubviews() {
        self.backgroundColor = .systemBackground
        
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        
        profileView.backgroundColor = .systemBackground
        self.addSubview(profileView)
        
        avatarImageView.contentMode = .scaleToFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = CGFloat(Constants.imageCornerRadius)
        avatarImageView.backgroundColor = .gray
        profileView.addSubview(avatarImageView)
        
        nickNameLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(Constants.largeFontSize))
        profileView.addSubview(nickNameLabel)
        
        accountIdLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.mediumFontSize))
        profileView.addSubview(accountIdLabel)
        
        favoriteButton.setTitle("", for: .normal)
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(changeFavoriteStatus(_:)), for: .touchUpInside)
        
        tableView.backgroundColor = .systemBackground
        self.addSubview(tableView)
    }
    
    func setConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.size.height * CGFloat(Constants.subviewOffsetMultiplier))
            make.trailing.leading.equalToSuperview()
            make.height.equalTo(110)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(CGFloat(Constants.smallConstraintOffset))
            make.height.width.equalTo(50)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(avatarImageView.snp.bottom).offset(CGFloat(Constants.smallConstraintOffset))
        }
        
        accountIdLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nickNameLabel.snp.bottom).offset(CGFloat(Constants.smallConstraintOffset))
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
        profileView.isHidden = true
        tableView.isHidden = true
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.activityIndicator.startAnimating()
            self.profileView.isHidden = false
            self.tableView.isHidden = false
        }
    }
    
    func setPlayerProfile(player: Player) {
        NetworkManager.shared.fetchImage(from: player.profile.avatarfull) { [weak self] imageData in
            self?.avatarImageView.image = UIImage(data: imageData)
        }
        
        nickNameLabel.text = player.profile.personaname
        accountIdLabel.text = "\(player.profile.account_id)"
        
        if favoritePlayers.filter({ $0.accountId == player.profile.account_id }).count != 0 {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
    @objc func changeFavoriteStatus(_: UIButton) {
        if let player = favoritePlayers.filter({ $0.accountId == player?.profile.account_id ?? 0 }).last {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            deleteFavoritePlayer?(player)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            if let player = player {
                createFavoritePlayer?(player.profile)
            }
        }
    }
}
//MARK: - Table view data source
extension PlayerDetailView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if matches.count > 6 {
                return 7
            } else {
                return matches.count + 1
            }
        } else {
            if favoriteHeroes.count != 0 {
                return 7
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TotalsTableViewCell.description(), for: indexPath)
                    as? TotalsTableViewCell else { return UITableViewCell() }
            
            if let summary = summary {
                cell.configure(withSummary: summary)
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 6 || indexPath.row == matches.count {
                guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.description(), for: indexPath) as? ButtonTableViewCell else { return UITableViewCell()}
                buttonCell.setLabelText(with: "Показать больше матчей")
                return buttonCell
            }
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MatchesTableViewCell.description(), for: indexPath)
                    as? MatchesTableViewCell else { return UITableViewCell() }
            
            if indexPath.row == 0 {
                cell.selectionStyle = .none
                cell.configureCellHeaders()
                return cell
            }
            
            var isWin = matches[indexPath.row].radiant_win
            let playerSlot = String(matches[indexPath.row].player_slot).count
            var gameMode = ""
            for (key, value) in gameModes {
                if key == "\(matches[indexPath.row].game_mode)" {
                    gameMode = value
                }
            }
            if playerSlot != 1 {
                isWin.toggle()
            }
            
            let hero = heroes.filter({ $0.id == matches[indexPath.row].hero_id }).last

            cell.configure(
                imagePath: hero?.img ?? "",
                isWin: isWin,
                gameMode: gameMode,
                kills: matches[indexPath.row].kills,
                deaths: matches[indexPath.row].deaths,
                assists: matches[indexPath.row].assists,
                playedTime: matches[indexPath.row].start_time + matches[indexPath.row].duration
            )
            return cell
            
        } else {
            if indexPath.row == 6 || indexPath.row == favoriteHeroes.count {
                guard let buttonCell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.description(), for: indexPath) as? ButtonTableViewCell else { return UITableViewCell()}
                buttonCell.setLabelText(with: "Показать всех героев")
                return buttonCell
            }
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FavoriteHeroTableViewCell.description(), for: indexPath)
                    as? FavoriteHeroTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            
            if indexPath.row == 0 {
                cell.configureCellHeaders()
                return cell
            }
            
            let hero = heroes.filter({ $0.id == favoriteHeroes[indexPath.row].hero_id }).last
            
            cell.configure(
                imagePath: hero?.img ?? "",
                heroName: hero?.localized_name ?? "",
                lastPlayed: favoriteHeroes[indexPath.row].last_played,
                wins: favoriteHeroes[indexPath.row].win,
                picks: favoriteHeroes[indexPath.row].games
            )
            return cell
        }
    }
}
//MARK: - Table view delegate
extension PlayerDetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            if indexPath.row == 6 || indexPath.row == matches.count + 1 {
                showAllElements?(heroes, gameModes, matches, [])
            } else {
                matchCellTapped?(heroes, gameModes, matches[indexPath.row].match_id)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 6 {
                showAllElements?(heroes, gameModes, [], favoriteHeroes)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 0 || indexPath.row == 6 || indexPath.row == matches.count + 1 {
                return CGFloat(Constants.smallCellHeight)
            } else {
                return CGFloat(Constants.bigCellHeight)
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 || indexPath.row == 6 {
                return CGFloat(Constants.smallCellHeight)
            } else {
                return CGFloat(Constants.bigCellHeight)
            }
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemBackground
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: CGFloat(Constants.headerFontSize))
        view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CGFloat(Constants.mediumConstraintOffset))
            make.centerY.equalToSuperview()
        }
        
        if section == 0 {
            headerLabel.text = "Данные игрока"
        } else if section == 1 {
            headerLabel.text = "Последние матчи"
        } else if section == 2 {
            headerLabel.text = "Любимые герои"
        }
        return view
    }
}

extension PlayerDetailView: PlayerDetailViewProtocol {
    func set(summary: Summary) {
        self.summary = summary
    }
    
    func set(player: Player) {
        self.player = player
    }
    
    func setMatches(with matches: [PlayerMatch]) {
        self.matches = matches
    }
    
    func setFavoriteHeroes(with heroes: [PlayersHero]) {
        self.favoriteHeroes = heroes
    }
    
    func set(gameModes: [String : String]) {
        self.gameModes = gameModes
    }
    
    func set(heroes: [Hero]) {
        self.heroes = heroes
    }
    
    func set(favoritePlayers: [FavoritePlayer]) {
        self.favoritePlayers = favoritePlayers
    }
    
    func errorDownloadData() {
        DispatchQueue.global().async {
            self.dataCount = 0
            self.stopActivityIndicator()
            DispatchQueue.main.async {
                self.showAlert?()
                self.startActivityIndicator()
            }
        }
    }
}
