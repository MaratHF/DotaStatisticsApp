//
//  Alert.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 18.06.2023.
//

import UIKit

final class Alert {
    static func createAlert(repeatHandler: @escaping (UIAlertAction) -> Void, cancelAction: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alert = UIAlertController(
            title: "Не удалось загрузить данные",
            message: "Повторить попытку загрузки?",
            preferredStyle: .alert
        )
        let repeatAction = UIAlertAction(title: "Повторить", style: .default, handler: repeatHandler)
        alert.addAction(repeatAction)
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: cancelAction)
        alert.addAction(cancelAction)
        return alert
    }
}
