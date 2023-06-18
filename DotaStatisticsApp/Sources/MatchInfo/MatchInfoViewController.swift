//
//  MatchInfoViewController.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 13.06.2023.
//

import UIKit

final class MatchInfoViewController: UIViewController {
    var heroes: [Hero] = []
    var gameModes: [String : String] = [:]
    
    private let matchId: Int
    private let matchInfoView = MatchInfoView()
    private let presenter: MatchInfoPresenter
    
    init(presenter: MatchInfoPresenter, matchId: Int) {
        self.presenter = presenter
        self.matchId = matchId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        view = matchInfoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad(ui: matchInfoView)
        matchInfoView.gameModes = gameModes
        matchInfoView.heroes = heroes
        
        matchInfoView.showAlert = { [weak self] in
            guard let self = self else { return }
            let alert = Alert.createAlert { _ in
                self.presenter.reloadData(matchId: self.matchId)
            } cancelAction: { _ in
                self.presenter.popToBackVC()
            }
            self.present(alert, animated: true)
        }
    }
}
