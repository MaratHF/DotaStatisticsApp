//
//  PlayerDetailViewController.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 10.06.2023.
//

import UIKit

final class PlayerDetailViewController: UIViewController {
    private let playerDetailView = PlayerDetailView()
    private let presenter: PlayerDetailPresenterProtocol
    private var id: Int
    
    init(presenter: PlayerDetailPresenter, id: Int) {
        self.presenter = presenter
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        view = playerDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        presenter.viewDidLoad(ui: playerDetailView)
        setHandlers()
    }
    
    private func setupNavBar() {
        let barButton = UIBarButtonItem(customView: playerDetailView.favoriteButton)
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func setHandlers() {
        playerDetailView.deleteFavoritePlayer = { [weak self] player in
            self?.presenter.deletePlayerFromFavorites(player: player)
        }
        
        playerDetailView.createFavoritePlayer = { [weak self] player in
            self?.presenter.addPlayerToFavorites(player: player)
        }
        
        playerDetailView.matchCellTapped = { [weak self] heroes, gameModes, id in
            let presenter = MatchInfoPresenter(matchId: id)
            let matchInfoVC = MatchInfoViewController(presenter: presenter)
            matchInfoVC.gameModes = gameModes
            matchInfoVC.heroes = heroes
            self?.navigationController?.pushViewController(matchInfoVC, animated: true)
        }
        
        playerDetailView.showAllElements = { [weak self] allHeroes, gameModes, matches, heroes in
            let presenter = MatchesAndHeroesViewPresenter(matches: matches, heroes: heroes)
            let matchesVC = MatchesAndHeroesViewController(presenter: presenter)
            matchesVC.gameModes = gameModes
            matchesVC.allHeroes = allHeroes
            self?.navigationController?.pushViewController(matchesVC, animated: true)
        }
        
        playerDetailView.showAlert = {
            let alert = NetworkManager.shared.createAlert { _ in
                self.presenter.reloadData(playerId: self.id)
            } cancelAction: { _ in
                self.navigationController?.popViewController(animated: true)
            }
            
            self.present(alert, animated: true)
        }
    }
}

