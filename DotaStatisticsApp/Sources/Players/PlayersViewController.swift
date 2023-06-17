//
//  PlayersViewController.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 06.06.2023.
//

import UIKit

class PlayersViewController: UIViewController {
    
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
        
        playersView.searchBarActionHandler = { [weak self] text in
            if let self = self {
                self.presenter.updatePlayers(withName: text, forUi: self.playersView)
            }
        }
        
        playersView.cellTappedHandler = { [weak self] id in
            let presenter = PlayerDetailPresenter(playerId: id)
            let playerDetailVC = PlayerDetailViewController(presenter: presenter, id: id)
            self?.navigationController?.pushViewController(playerDetailVC, animated: true)
        }
    }
}

