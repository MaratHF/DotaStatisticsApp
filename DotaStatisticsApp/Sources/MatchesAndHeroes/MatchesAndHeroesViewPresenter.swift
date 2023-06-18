//
//  MatchesViewPresenter.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 16.06.2023.
//

import Foundation

protocol MatchesAndHeroesViewPresenterProtocol: AnyObject {
    func viewDidLoad(ui: MatchesAndHeroesViewProtocol)
    func cellTapped(id: Int, heroes: [Hero], gameModes: [String:String])
}

final class MatchesAndHeroesViewPresenter {
    private var matches: [PlayerMatch] = []
    private var heroes: [PlayersHero] = []
    private var router: RouterProtocol?
    
    init(matches: [PlayerMatch], heroes: [PlayersHero], router: RouterProtocol) {
        self.matches = matches
        self.heroes = heroes
        self.router = router
    }
}

extension MatchesAndHeroesViewPresenter: MatchesAndHeroesViewPresenterProtocol {
    func viewDidLoad(ui: MatchesAndHeroesViewProtocol) {
        ui.set(matches: matches, andHeroes: heroes)
    }
    
    func cellTapped(id: Int, heroes: [Hero], gameModes: [String : String]) {
        router?.showMatchInfo(matchId: id, gameModes: gameModes, heroes: heroes)
    }
}
