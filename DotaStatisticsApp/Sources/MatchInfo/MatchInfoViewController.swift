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
    private let matchInfoView = MatchInfoView()
    private let presenter: MatchInfoPresenter
    
    init(presenter: MatchInfoPresenter) {
        self.presenter = presenter
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
    }
}
