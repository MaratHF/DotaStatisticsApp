//
//  MatchInfoPresenter.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 13.06.2023.
//

import Foundation

protocol MatchInfoPresenterProtocol: AnyObject {
    func viewDidLoad(ui: MatchInfoViewProtocol)
    func reloadData(matchId: Int)
    func popToBackVC()
}

final class MatchInfoPresenter {
    private var ui: MatchInfoViewProtocol?
    private var router: RouterProtocol?
    private var itemsById: [String : String] = [:]
    private var itemsByName: [String : Item] = [:]
    
    init(matchId: Int, router: RouterProtocol) {
        self.router = router
        fetchMatch(matchId: matchId)
        fetchItemsById()
        fetchItemsByName()
    }
    
    private func fetchMatch(matchId: Int) {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.allMatchesPath.rawValue + "\(matchId)")
        
        NetworkManager.shared.fetch(dataType: Match.self, from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let match):
                self.ui?.set(match: match)
            case .failure(_):
                self.ui?.errorDownloadData()
            }
        }
    }
    
    private func fetchItemsById() {
        let url = URL(string: UrlPath.baseUrl.rawValue + UrlPath.itemIdsPath.rawValue)
        NetworkManager.shared.fetch(dataType: [String : String].self, from: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let itemsById):
                self.ui?.set(itemsById: itemsById)
            case .failure(_):
                self.ui?.errorDownloadData()
            }
        }
    }
    
    private func fetchItemsByName() {
        let itemsUrl = URL(string: UrlPath.baseUrl.rawValue + UrlPath.itemsPath.rawValue)
        NetworkManager.shared.fetch(dataType: [String : Item].self, from: itemsUrl) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let itemsByName):
                self.ui?.set(itemsByName: itemsByName)
            case .failure(_):
                self.ui?.errorDownloadData()
            }
        }
    }
}

extension MatchInfoPresenter: MatchInfoPresenterProtocol {
    func viewDidLoad(ui: MatchInfoViewProtocol) {
        self.ui = ui
    }
    
    func reloadData(matchId: Int) {
        fetchMatch(matchId: matchId)
        fetchItemsById()
        fetchItemsByName()
    }
    
    func popToBackVC() {
        router?.popToBackVC()
    }
}
