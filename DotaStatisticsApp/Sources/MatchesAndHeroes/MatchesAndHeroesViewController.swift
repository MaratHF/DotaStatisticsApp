//
//  MatchesAndHeroesViewController.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 16.06.2023.
//

import UIKit

final class MatchesAndHeroesViewController: UIViewController {
    var gameModes: [String : String] = [:]
    var allHeroes: [Hero] = []
    private var matchesView = MatchesAndHeroesView()
    private var presenter: MatchesAndHeroesViewPresenterProtocol
    
    init(presenter: MatchesAndHeroesViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        view = matchesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad(ui: matchesView)
        
        matchesView.gameModes = gameModes
        matchesView.allHeroes = allHeroes
        matchesView.matchCellTapped = { [weak self] id in
            let presenter = MatchInfoPresenter(matchId: id)
            let matchInfoVC = MatchInfoViewController(presenter: presenter)
            self?.navigationController?.pushViewController(matchInfoVC, animated: true)
        }
    }
}
