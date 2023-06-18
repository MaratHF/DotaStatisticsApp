//
//  ButtonTableViewCell.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 13.06.2023.
//

import UIKit
import SnapKit

final class ButtonTableViewCell: UITableViewCell {
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelText(with text: String) {
        label.text = text
    }
    
    private func setLabel() {
        label.textColor = .systemBlue
        self.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
