//
//  PlayerDetailPresenter.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 11.06.2023.
//

import Foundation

protocol PlayerDetailPresenterProtocol: AnyObject {
    func viewDidLoad(ui: PlayerDetailViewProtocol)
    func reloadData(playerId: Int)
    func deletePlayerFromFavorites(player: FavoritePlayer)
    func addPlayerToFavorites(player: Profile)
    func cellTapped(heroes: [Hero], gameModes: [String : String], id: Int)
    func buttonCellTapped(allHeroes: [Hero], gameModes: [String:String], matches: [PlayerMatch], heroes: [PlayersHero])
    func popToBackVC()
}

final class PlayerDetailPresenter {
    private var ui: PlayerDetailViewProtocol?
    private var router: RouterProtocol?
    
    // А нахуя теперь summary? И без него ведь ждем пока данные загрузятся?
    private var summaryCount = 0
    private var summary: Summary = Summary() {
        didSet {
            if summaryCount == 4 {
                ui?.set(summary: summary)
            }
        }
    }
    
    init(playerId: Int, router: RouterProtocol) {
        self.router = router
        fetchHeroes()
        fetchGameMode()
        fetchPlayer(playerId: playerId)
        fetchPlayerTotals(playerId: playerId)
        fetchWinLose(playerId: playerId)
        fetchMatches(forPlayerId: playerId)
        fetchFavoriteHeroes(playerId: playerId)
    }
    
    private func fetchGameMode() {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.gameModePath.rawValue)
        NetworkManager.shared.fetch(dataType: [String : GameMode].self, from: url) { [weak self] result in
            guard let self = self else { return }
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
                self.ui?.set(gameModes: dict)
            case .failure(_):
                self.ui?.errorDownloadData()
            }
        }
    }
    
    private func fetchFavoriteHeroes(playerId: Int) {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.playerIdPath.rawValue + "\(playerId)" + UrlPath.favoriteHeroesPath.rawValue)
        NetworkManager.shared.fetch(dataType: [PlayersHero].self, from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let heroes):
                let favoriteHeroes = heroes.sorted(by: { $0.games > $1.games })
                self.ui?.setFavoriteHeroes(with: favoriteHeroes)
            case .failure(_):
                print("Favorite Heroes Failed")
                self.ui?.errorDownloadData()
            }
        }
    }
    
    private func fetchWinLose(playerId: Int) {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.playerIdPath.rawValue + "\(playerId)" + UrlPath.winLosePath.rawValue)
        NetworkManager.shared.fetch(dataType: WinLose.self, from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let winLose):
                self.summaryCount += 1
                self.summary.winLose = winLose
            case .failure(_):
                self.summaryCount = 0
                self.ui?.errorDownloadData()
            }
        }
    }
    
    private func fetchPlayerTotals(playerId: Int) {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.playerIdPath.rawValue + "\(playerId)" + UrlPath.totalsPath.rawValue)
        NetworkManager.shared.fetch(dataType: [PlayerTotals].self, from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let totals):
                self.summaryCount += 1
                self.summary.playerTotals = totals
            case .failure(_):
                self.summaryCount = 0
                self.ui?.errorDownloadData()
            }
        }
    }
    
    private func fetchPlayer(playerId: Int) {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.playerIdPath.rawValue + "\(playerId)")
        NetworkManager.shared.fetch(dataType: Player.self, from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let player):
                self.summaryCount += 1
                self.summary.rankTier = player.rank_tier
                self.ui?.set(player: player)
            case .failure(_):
                self.summaryCount = 0
                self.ui?.errorDownloadData()
            }
        }
    }
    
    private func fetchMatches(forPlayerId id: Int) {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.playerIdPath.rawValue + "\(id)" + UrlPath.playerMatchesPath.rawValue) 
        NetworkManager.shared.fetch(dataType: [PlayerMatch].self, from: url) { [weak self] result in
            if let self = self {
                switch result {
                case .success(let matches):
                    self.summaryCount += 1
                    self.summary.matchesCount = matches.count
                    
                    var recentMatches: [PlayerMatch] = []
                    matches.forEach { match in
                        if recentMatches.count <= 20 {
                            recentMatches.append(match)
                        }
                    }
                    self.ui?.setMatches(with: recentMatches)
                case .failure(_):
                    self.summaryCount = 0
                    self.ui?.errorDownloadData()
                }
            }
        }
    }
    
    private func fetchHeroes() {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.allHeroesPath.rawValue)
        NetworkManager.shared.fetch(dataType: [Hero].self, from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let heroes):
                self.ui?.set(heroes: heroes)
            case .failure(_):
                self.ui?.errorDownloadData()
            }
        }
    }
    
    private func fetchFavoritesPlayers() {
        StorageManager.shared.fetchData { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let players):
                self.ui?.set(favoritePlayers: players)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension PlayerDetailPresenter: PlayerDetailPresenterProtocol {
    func reloadData(playerId: Int) {
        fetchHeroes()
        fetchGameMode()
        fetchFavoritesPlayers()
        fetchPlayer(playerId: playerId)
        fetchPlayerTotals(playerId: playerId)
        fetchWinLose(playerId: playerId)
        fetchMatches(forPlayerId: playerId)
        fetchFavoriteHeroes(playerId: playerId)
    }
    
    func viewDidLoad(ui: PlayerDetailViewProtocol) {
        self.ui = ui
        fetchFavoritesPlayers()
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
    
    func cellTapped(heroes: [Hero], gameModes: [String : String], id: Int) {
        router?.showMatchInfo(matchId: id, gameModes: gameModes, heroes: heroes)
    }
    
    func buttonCellTapped(allHeroes: [Hero], gameModes: [String : String], matches: [PlayerMatch], heroes: [PlayersHero]) {
        router?.showMatchesAndHeroes(matches: matches, heroes: heroes, allHeroes: allHeroes, gameModes: gameModes)
    }
    
    func popToBackVC() {
        router?.popToBackVC()
    }
}
