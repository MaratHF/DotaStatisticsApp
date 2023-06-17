//
//  MatchesViewPresenter.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 16.06.2023.
//

import Foundation

protocol MatchesAndHeroesViewPresenterProtocol {
    func viewDidLoad(ui: MatchesAndHeroesViewProtocol)
}

final class MatchesAndHeroesViewPresenter {
    private var matches: [PlayerMatch] = []
    private var heroes: [PlayersHero] = []
    
    init(matches: [PlayerMatch], heroes: [PlayersHero]) {
        self.matches = matches
        self.heroes = heroes
    }
}

extension MatchesAndHeroesViewPresenter: MatchesAndHeroesViewPresenterProtocol {
    func viewDidLoad(ui: MatchesAndHeroesViewProtocol) {
        ui.set(matches: matches, andHeroes: heroes)
    }
}
