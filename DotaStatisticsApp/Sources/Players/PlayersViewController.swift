//
//  PlayersViewController.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 06.06.2023.
//

import UIKit
import CloudKit

final class PlayersViewController: UIViewController {
    
    private let playersView = PlayersView()
    private let presenter: PlayersPresenterProtocol
    
    init(presenter: PlayersPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = playersView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Поиск игроков"
        navigationItem.backButtonTitle = "Назад"
        setViewHandlers()
    }
    
    private func setViewHandlers() {
        playersView.searchBarActionHandler = { [weak self] text in
            guard let self = self else { return }
            self.presenter.updatePlayers(withName: text, forUi: self.playersView)
        }
        
        playersView.cellTappedHandler = { [weak self] id in
            guard let self = self else { return }
            self.presenter.cellTapped(id: id)
        }
    }
}

