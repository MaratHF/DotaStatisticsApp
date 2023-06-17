//
//  MatchInfoPresenter.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 13.06.2023.
//

import Foundation

protocol MatchInfoPresenterProtocol {
    func viewDidLoad(ui: MatchInfoViewProtocol)
}

final class MatchInfoPresenter {
    private var ui: MatchInfoViewProtocol?
    private var match: Match? {
        didSet {
            if let match = match {
                ui?.set(match: match)
            }
        }
    }
    private var itemsById: [String : String] = [:]
    private var itemsByName: [String : Item] = [:]
    
    init(matchId: Int) {
        fetchMatch(playerId: matchId)
        fetchItemsById()
        fetchItemsByName()
    }
    
    private func fetchMatch(playerId: Int) {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.allMatchesPath.rawValue + "\(playerId)")
        
        NetworkManager.shared.fetch(dataType: Match.self, from: url) { result in
            switch result {
            case .success(let match):
                self.match = match
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchItemsById() {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.itemIdsPath.rawValue)
        NetworkManager.shared.fetch(dataType: [String : String].self, from: url) { [weak self] result in
            switch result {
            case .success(let itemsById):
                self?.ui?.set(itemsById: itemsById)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchItemsByName() {
        let itemsUrl = URL(string: UrlPath.baseUrl.rawValue + UrlPath.itemsPath.rawValue)
        NetworkManager.shared.fetch(dataType: [String : Item].self, from: itemsUrl) { [weak self] result in
            switch result {
            case .success(let itemsByName):
                self?.ui?.set(itemsByName: itemsByName)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension MatchInfoPresenter: MatchInfoPresenterProtocol {
    func viewDidLoad(ui: MatchInfoViewProtocol) {
        self.ui = ui
    }
}
