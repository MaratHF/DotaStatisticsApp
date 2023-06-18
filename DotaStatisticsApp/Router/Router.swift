//
//  Router.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 17.06.2023.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showPlayers()
    func showPlayerDetail(id: Int)
    func showMatchesAndHeroes(matches: [PlayerMatch], heroes: [PlayersHero], allHeroes: [Hero], gameModes: [String:String])
    func showMatchInfo(matchId: Int, gameModes: [String:String], heroes: [Hero])
    func popToBackVC()
}

final class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let favoritePlayerVC = assemblyBuilder?.createMainModule(router: self) else { return }
            navigationController.viewControllers.append(favoritePlayerVC)
        }
    }
    
    func showPlayers() {
        if let navigationController = navigationController {
            guard let playersVC = assemblyBuilder?.createPlayersModule(router: self) else { return }
            navigationController.pushViewController(playersVC, animated: true)
        }
    }
    
    func showPlayerDetail(id: Int) {
        if let navigationController = navigationController {
            guard let playerDetailVC = assemblyBuilder?.createPlayerDetailModule(playerId: id, router: self) else { return }
            navigationController.pushViewController(playerDetailVC, animated: true)
        }
    }
    
    func showMatchesAndHeroes(matches: [PlayerMatch], heroes: [PlayersHero], allHeroes: [Hero], gameModes: [String:String]) {
        if let navigationController = navigationController {
            guard let matchAndHeroesVC = assemblyBuilder?.createMatchesAndHeroesModule(
                matches: matches,
                heroes: heroes,
                allHeroes: allHeroes,
                gameModes: gameModes,
                router: self
            ) else { return }
            navigationController.pushViewController(matchAndHeroesVC, animated: true)
        }
    }
    
    func showMatchInfo(matchId: Int, gameModes: [String:String], heroes: [Hero]) {
        if let navigationController = navigationController {
            guard let matchInfoVC = assemblyBuilder?.createMatchInfoModule(
                matchId: matchId,
                gameModes: gameModes,
                heroes: heroes,
                router: self
            ) else { return }
            navigationController.pushViewController(matchInfoVC, animated: true)
        }
    }
    
    func popToBackVC() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
