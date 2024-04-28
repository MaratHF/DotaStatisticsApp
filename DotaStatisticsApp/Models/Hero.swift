//
//  Hero.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 11.06.2023.
//

import Foundation

struct Hero: Decodable {
    let id: Int
    let img: String
    let localized_name: String
}

struct PlayersHero: Decodable {
    let hero_id: Int
    let last_played: Int
    let games: Int
    let win: Int
}
