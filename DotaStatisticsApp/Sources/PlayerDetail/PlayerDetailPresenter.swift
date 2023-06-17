//
//  PlayerDetailPresenter.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 11.06.2023.
//

import Foundation

protocol PlayerDetailPresenterProtocol {
    func viewDidLoad(ui: PlayerDetailViewProtocol)
    func reloadData(playerId: Int)
    func deletePlayerFromFavorites(player: FavoritePlayer)
    func addPlayerToFavorites(player: Profile)
}

final class PlayerDetailPresenter {
    private var ui: PlayerDetailViewProtocol?
    
    private var summary: Summary = Summary() {
        didSet {
            ui?.set(summary: summary)
        }
    }
    
    init(playerId: Int) {
        fetchPlayer(playerId: playerId)
        fetchPlayerTotals(playerId: playerId)
        fetchWinLose(playerId: playerId)
        fetchHeroes()
        fetchGameMode()
        fetchMatches(forPlayerId: playerId)
        fetchFavoriteHeroes(playerId: playerId)
    }
    
    private func fetchGameMode() {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.gameModePath.rawValue)
        NetworkManager.shared.fetch(dataType: [String : GameMode].self, from: url) { [weak self] result in
            switch result {
            case .success(let gameModes):
                var dict: [String : String] = [:]
                for (key, value) in gameModes {
                    let gameMode = value.name.components(separatedBy: "_")
                    let gameModeWords = gameMode[2...(gameMode.count - 1)]
                    var name = ""
                    for word in gameModeWords {
                        name += " " + word.capitalized
                    }
                    dict[key] = name
                }
                self?.ui?.set(gameModes: dict)
            case .failure(_):
                self?.ui?.addError()
            }
        }
    }
    
    private func fetchFavoriteHeroes(playerId: Int) {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.playerIdPath.rawValue + "\(playerId)" + UrlPath.favoriteHeroesPath.rawValue)
        
        NetworkManager.shared.fetch(dataType: [PlayersHero].self, from: url) { [weak self] result in
            switch result {
            case .success(let heroes):
                let favoriteHeroes = heroes.sorted(by: { $0.games > $1.games })
                self?.ui?.setFavoriteHeroes(with: favoriteHeroes)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchWinLose(playerId: Int) {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.playerIdPath.rawValue + "\(playerId)" + UrlPath.winLosePath.rawValue)
        NetworkManager.shared.fetch(dataType: WinLose.self, from: url) { [weak self] result in
            switch result {
            case .success(let winLose):
                self?.summary.winLose = winLose
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchPlayerTotals(playerId: Int) {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.playerIdPath.rawValue + "\(playerId)" + UrlPath.totalsPath.rawValue)
        NetworkManager.shared.fetch(dataType: [PlayerTotals].self, from: url) { [weak self] result in
            switch result {
            case .success(let totals):
                self?.summary.playerTotals = totals
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchPlayer(playerId: Int) {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.playerIdPath.rawValue + "\(playerId)")
        NetworkManager.shared.fetch(dataType: Player.self, from: url) { [weak self] result in
            switch result {
            case .success(let player):
                self?.summary.rankTier = player.rank_tier
                self?.ui?.set(player: player)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchMatches(forPlayerId id: Int) {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.playerIdPath.rawValue + "\(id)" + UrlPath.playerMatchesPath.rawValue) 
        NetworkManager.shared.fetch(dataType: [PlayerMatch].self, from: url) { [weak self] result in
            if let self = self {
                switch result {
                case .success(let matches):
                    self.summary.matchesCount = matches.count
                    
                    var recentMatches: [PlayerMatch] = []
                    matches.forEach { match in
                        if recentMatches.count <= 20 {
                            recentMatches.append(match)
                        }
                    }
                    self.ui?.setMatches(with: recentMatches)
                    self.fetchGameMode()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchHeroes() {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.allHeroesPath.rawValue)
        NetworkManager.shared.fetch(dataType: [Hero].self, from: url) { [weak self] result in
            switch result {
            case .success(let heroes):
                self?.ui?.set(heroes: heroes)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}

extension PlayerDetailPresenter: PlayerDetailPresenterProtocol {
    func reloadData(playerId: Int) {
        fetchPlayer(playerId: playerId)
        fetchPlayerTotals(playerId: playerId)
        fetchWinLose(playerId: playerId)
        fetchHeroes()
        fetchMatches(forPlayerId: playerId)
        fetchFavoriteHeroes(playerId: playerId)
        fetchGameMode()
    }
    
    func viewDidLoad(ui: PlayerDetailViewProtocol) {
        self.ui = ui
    }
    
    func deletePlayerFromFavorites(player: FavoritePlayer) {
        StorageManager.shared.delete(favoritePlayer: player)
    }
    
    func addPlayerToFavorites(player: Profile) {
        StorageManager.shared.create(
            id: player.account_id,
            name: player.personaname ?? "player name",
            image: player.avatarfull ?? ""
        )
    }
}
