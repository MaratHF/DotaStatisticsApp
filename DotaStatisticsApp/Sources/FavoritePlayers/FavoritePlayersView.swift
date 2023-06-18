//
//  FavoritesPlayerView.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 15.06.2023.
//

import UIKit
import SnapKit

protocol FavoritePlayersViewProtocol: AnyObject {
    func set(favoritePlayers: [Profile])
}

final class FavoritePlayersView: SearchView {
    override init() {
        super.init()
        searchBar.delegate = self
        setInfoLabelText()
        selectSubview()
        
        action = { [weak self] in
            self?.tableView.reloadData()
            self?.selectSubview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setInfoLabelText() {
        infoLabel.text = """
Здесь будут отображаться
ваши избранные игроки
"""
    }
    
    private func selectSubview() {
        if players.count == 0 {
            infoLabel.isHidden = false
            tableView.isHidden = true
        } else {
            infoLabel.isHidden = true
            tableView.isHidden = false
        }
    }
}
// MARK: - Search Bar Delegate
extension FavoritePlayersView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarActionHandler?("")
        searchBar.resignFirstResponder()
    }
}

// MARK: - FavoritePlayersViewProtocol
extension FavoritePlayersView: FavoritePlayersViewProtocol {
    func set(favoritePlayers: [Profile]) {
        self.players = favoritePlayers
    }
}


