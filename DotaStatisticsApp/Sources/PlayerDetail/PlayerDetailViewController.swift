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
    private let id: Int
    
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
        navigationItem.backButtonTitle = "Назад"
        let barButton = UIBarButtonItem(customView: playerDetailView.favoriteButton)
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func setHandlers() {
        playerDetailView.deleteFavoritePlayer = { [weak self] player in
            guard let self = self else { return }
            self.presenter.deletePlayerFromFavorites(player: player)
        }
        
        playerDetailView.createFavoritePlayer = { [weak self] player in
            guard let self = self else { return }
            self.presenter.addPlayerToFavorites(player: player)
        }
        
        playerDetailView.matchCellTapped = { [weak self] heroes, gameModes, id in
            guard let self = self else { return }
            self.presenter.cellTapped(heroes: heroes, gameModes: gameModes, id: id)
        }
        
        playerDetailView.showAllElements = { [weak self] allHeroes, gameModes, matches, heroes in
            guard let self = self else { return }
            self.presenter.buttonCellTapped(
                allHeroes: allHeroes,
                gameModes: gameModes,
                matches: matches,
                heroes: heroes
            )
        }
        
        playerDetailView.showAlert = { [weak self] in
            guard let self = self else { return }
            let alert = Alert.createAlert { _ in
                self.presenter.reloadData(playerId: self.id)
            } cancelAction: { _ in
                self.presenter.popToBackVC()
            }
            
            self.present(alert, animated: true)
        }
    }
}

