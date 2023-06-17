//
//  FavoritePlayersViewController.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 15.06.2023.
//

import UIKit

final class FavoritePlayersViewController: UIViewController {
    private let favoritePlayersView = FavoritePlayersView()
    private let presenter: FavoritePlayersPresenterProtocol
    
    init(presenter: FavoritePlayersPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = favoritePlayersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad(ui: favoritePlayersView)
        presenter.setFavoritePlayers(forUi: favoritePlayersView)
        
        favoritePlayersView.searchBarActionHandler = { [weak self] _ in
            let presenter = PlayersPresenter()
            let playersVC = PlayersViewController(presenter: presenter)
            self?.navigationController?.pushViewController(playersVC, animated: true)
        }
        
        favoritePlayersView.cellTappedHandler = { [weak self] id in
            let presenter = PlayerDetailPresenter(playerId: id)
            let playerDetailVC = PlayerDetailViewController(presenter: presenter, id: id)
            self?.navigationController?.pushViewController(playerDetailVC, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.setFavoritePlayers(forUi: favoritePlayersView)
    }
}
