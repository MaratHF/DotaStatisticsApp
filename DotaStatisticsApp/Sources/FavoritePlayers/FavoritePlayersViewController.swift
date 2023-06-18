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
        
        title = "Избранные игроки"
        navigationItem.backButtonTitle = "Назад"
        
        presenter.viewDidLoad(ui: favoritePlayersView)
        presenter.setFavoritePlayers(forUi: favoritePlayersView)
        setViewHandlers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.setFavoritePlayers(forUi: favoritePlayersView)
    }
    
    private func setViewHandlers() {
        favoritePlayersView.searchBarActionHandler = { [weak self] _ in
            guard let self = self else { return }
            self.presenter.searchBarTapped()
        }
        
        favoritePlayersView.cellTappedHandler = { [weak self] id in
            guard let self = self else { return }
            self.presenter.cellTapped(id: id)
        }
    }
}
