//
//  FavoritePlayersPresenter.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 15.06.2023.
//

import Foundation

protocol FavoritePlayersPresenterProtocol: AnyObject {
    func viewDidLoad(ui: FavoritePlayersViewProtocol)
    func setFavoritePlayers(forUi  ui: FavoritePlayersViewProtocol)
    func searchBarTapped()
    func cellTapped(id: Int)
}

final class FavoritePlayersPresenter {
    private var ui: FavoritePlayersViewProtocol?
    private var router: RouterProtocol?
    private var favoritePlayers: [Profile] = [] {
        didSet {
            ui?.set(favoritePlayers: favoritePlayers)
        }
    }
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    private func fetchPlayers() {
        StorageManager.shared.fetchData { result in
            switch result {
            case .success(let players):
                favoritePlayers.removeAll()
                for player in players {
                    favoritePlayers.append(Profile(
                        account_id: Int(player.accountId),
                        personaname: player.personaName,
                        avatarfull: player.avatarImage
                    ))
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension FavoritePlayersPresenter: FavoritePlayersPresenterProtocol {
    func searchBarTapped() {
        router?.showPlayers()
    }
    
    func cellTapped(id: Int) {
        router?.showPlayerDetail(id: id)
    }
    
    func viewDidLoad(ui: FavoritePlayersViewProtocol) {
        self.ui = ui
    }
    
    func setFavoritePlayers(forUi ui: FavoritePlayersViewProtocol) {
        fetchPlayers()
    }
}

