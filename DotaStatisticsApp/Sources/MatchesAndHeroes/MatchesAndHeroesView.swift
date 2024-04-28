//
//  MatchesAndHeroesView.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 16.06.2023.
//

import UIKit

protocol MatchesAndHeroesViewProtocol: AnyObject {
    func set(matches: [PlayerMatch], andHeroes heroes: [PlayersHero])
}

final class MatchesAndHeroesView: UIView {
    var allHeroes: [Hero] = []
    var gameModes: [String :String] = [:]
    var matchCellTapped: ((Int) -> Void)?
    
    private var matches: [PlayerMatch] = []
    private var heroes: [PlayersHero] = []
    private lazy var tableView = makeTableView()
    
    init() {
        super.init(frame: .zero)
       setTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(MatchesTableViewCell.self, forCellReuseIdentifier: MatchesTableViewCell.description())
        tableView.register(FavoriteHeroTableViewCell.self, forCellReuseIdentifier: FavoriteHeroTableViewCell.description())
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }
    
    private func setTableView() {
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = CGFloat(Constants.bigCellHeight)
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
// MARK: - Table view delegate and data source
extension MatchesAndHeroesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if matches.count != 0 {
            return matches.count
        } else {
            return heroes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if matches.count != 0 {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MatchesTableViewCell.description(), for: indexPath)
                    as? MatchesTableViewCell else { return UITableViewCell() }
            
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
            
            let hero = allHeroes.filter({ $0.id == matches[indexPath.row].hero_id }).last
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
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FavoriteHeroTableViewCell.description(), for: indexPath)
                    as? FavoriteHeroTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            let hero = allHeroes.filter({ $0.id == heroes[indexPath.row].hero_id }).last
            cell.configure(
                imagePath: hero?.img ?? "",
                heroName: hero?.localized_name ?? "",
                lastPlayed: heroes[indexPath.row].last_played,
                wins: heroes[indexPath.row].win,
                picks: heroes[indexPath.row].games
            )
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        matchCellTapped?(matches[indexPath.row].match_id)
    }
}

extension MatchesAndHeroesView: MatchesAndHeroesViewProtocol {
    func set(matches: [PlayerMatch], andHeroes heroes: [PlayersHero]) {
        self.matches = matches
        self.heroes = heroes
    }
}
