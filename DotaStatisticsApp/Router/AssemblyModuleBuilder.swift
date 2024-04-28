//
//  AssemblyBuilder.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 17.06.2023.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createPlayersModule(router: RouterProtocol) -> UIViewController
    func createPlayerDetailModule(playerId: Int, router: RouterProtocol) -> UIViewController
    func createMatchesAndHeroesModule(matches: [PlayerMatch], heroes: [PlayersHero], allHeroes: [Hero], gameModes: [String : String], router: RouterProtocol) -> UIViewController
    func createMatchInfoModule(matchId: Int, gameModes: [String : String], heroes: [Hero], router: RouterProtocol) -> UIViewController
}

final class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let presenter = FavoritePlayersPresenter(router: router)
        let favoritePlayersVC = FavoritePlayersViewController(presenter: presenter)
        return favoritePlayersVC
    }
    
    func createPlayersModule(router: RouterProtocol) -> UIViewController {
        let presenter = PlayersPresenter(router: router)
        let playersVC = PlayersViewController(presenter: presenter)
        return playersVC
    }
    
    func createPlayerDetailModule(playerId: Int, router: RouterProtocol) -> UIViewController {
        let presenter = PlayerDetailPresenter(playerId: playerId, router: router)
        let playerDetailVC = PlayerDetailViewController(presenter: presenter, id: playerId)
        return playerDetailVC
    }
    
    func createMatchesAndHeroesModule(matches: [PlayerMatch], heroes: [PlayersHero], allHeroes: [Hero], gameModes: [String : String], router: RouterProtocol) -> UIViewController {
        let presenter = MatchesAndHeroesViewPresenter(matches: matches, heroes: heroes, router: router)
        let matchesVC = MatchesAndHeroesViewController(presenter: presenter)
        matchesVC.gameModes = gameModes
        matchesVC.allHeroes = allHeroes
        return matchesVC
    }
    
    func createMatchInfoModule(matchId: Int, gameModes: [String : String], heroes: [Hero], router: RouterProtocol) -> UIViewController {
        let presenter = MatchInfoPresenter(matchId: matchId, router: router)
        let matchInfoVC = MatchInfoViewController(presenter: presenter, matchId: matchId)
        matchInfoVC.gameModes = gameModes
        matchInfoVC.heroes = heroes
        return matchInfoVC
    }
}
