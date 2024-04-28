//
//  SearchView.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 15.06.2023.
//

import UIKit

class SearchView: UIView {
    var players: [Profile] = [] {
        didSet {
            action()
        }
    }
    var action: () -> Void = {}
    var searchBar = UISearchBar()
    lazy var tableView = makeTableView()
    var infoLabel = UILabel()
    
    var searchBarActionHandler: ((String) -> Void)?
    var cellTappedHandler: ((Int) -> Void)?
    
    init() {
        super.init(frame: .zero)
        setupSubviews()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Private methods
private extension SearchView {
    func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.register(PlayersTableViewCell.self, forCellReuseIdentifier: PlayersTableViewCell.description())
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }
    
    func setupSubviews() {
        self.backgroundColor = .systemBackground
        
        searchBar.barTintColor = .systemBackground
        if searchBar.text == "" {
            searchBar.placeholder = "Введите имя или id игрока"
        } else {
            searchBar.placeholder = nil
        }
        self.addSubview(searchBar)
        
        tableView.backgroundColor = .systemBackground
        tableView.rowHeight = CGFloat(Constants.bigCellHeight)
        self.addSubview(tableView)
        
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.isHidden = true
        self.addSubview(infoLabel)
    }
    
    func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
    }
}
// MARK: - Table View Data Source And Delegate
extension SearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlayersTableViewCell.description(), for: indexPath)
                as? PlayersTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .systemBackground
        let profile = players[indexPath.row]
        cell.configure(with: profile)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let id = players[indexPath.row].account_id
        cellTappedHandler?(id)
    }
}

// MARK: - UITableVIew
extension UITableView {
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let view = UIView()
            view.backgroundColor = .gray
            let activityView = UIActivityIndicatorView(style: .medium)
            view.addSubview(activityView)
            activityView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(UIScreen.main.bounds.height/4)
                make.centerX.equalToSuperview()
            }
            self.backgroundView = view
            activityView.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
}
