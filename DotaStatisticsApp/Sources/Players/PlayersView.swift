//
//  PlayersView.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 07.06.2023.
//

import UIKit
import SnapKit

protocol PlayersViewProtocol: AnyObject {
    func set(players: [Profile])
}

final class PlayersView: SearchView {
    override init() {
        super.init()
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        action = { [weak self] in
            self?.tableView.hideActivityIndicator()
            self?.tableView.reloadData()
        }
        
        setInfoLabelText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setInfoLabelText() {
        infoLabel.text = """
Ничего не найдено

Для поиска необходимо
ввести хотя бы 3 символа
"""
    }
}
// MARK: - Search Bar Delegate
extension PlayersView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.showActivityIndicator()
        searchBarActionHandler?(searchText)
        if (1...2).contains(searchText.count)  {
            tableView.isHidden = true
            infoLabel.isHidden = false
        } else {
            tableView.isHidden = false
            infoLabel.isHidden = true
        }
    }
}
// MARK: - Players View Protocol
extension PlayersView: PlayersViewProtocol {
    func set(players: [Profile]) {
        self.players = players
    }
}
