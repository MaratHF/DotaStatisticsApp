//
//  PlayersPresenter.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 10.06.2023.
//

import Foundation

protocol PlayersPresenterProtocol: AnyObject {
    func updatePlayers(withName text: String, forUi ui: PlayersViewProtocol)
}

final class PlayersPresenter {
    private var players: [Profile] = []
}

extension PlayersPresenter: PlayersPresenterProtocol {
    
    func updatePlayers(withName text: String, forUi ui: PlayersViewProtocol) {
        players.removeAll()
        if let id = Int(text) {
            let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.playerIdPath.rawValue + String(id))
            NetworkManager.shared.fetch(dataType: Player.self, from: url) { result in
                switch result {
                case .success(let player):
                    self.players.append(player.profile)
                    ui.set(players: self.players)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = UrlPath.scheme.rawValue
        urlComponents.host = UrlPath.host.rawValue
        urlComponents.path = UrlPath.searchNamePath.rawValue
        urlComponents.queryItems = [URLQueryItem(name: UrlPath.searchNameQuery.rawValue, value: text)]
        let url = urlComponents.url
    
        NetworkManager.shared.fetch(dataType: [Profile].self, from: url) { result in
            switch result {
            case .success(let filteredPlayers):
                self.players = filteredPlayers
                ui.set(players: self.players)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
