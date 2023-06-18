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
        setActionForPlayersChange()
        setInfoLabelText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setActionForPlayersChange() {
        action = { [weak self] in
            guard let self = self else { return }
            self.tableView.hideActivityIndicator()
            self.tableView.reloadData()
            if self.players.isEmpty {
                self.tableView.isHidden = true
                self.infoLabel.isHidden = false
            }
        }
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
        if (0...2).contains(searchText.count)  {
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
