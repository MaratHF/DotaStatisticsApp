//
//  Match.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 10.06.2023.
//

import Foundation

struct Match: Decodable {
    let match_id: Int
    let dire_score: Int
    let game_mode: Int
    let duration: Int
    let radiant_score: Int
    let radiant_win: Bool
    let players: [MatchPlayer]
}

struct MatchPlayer: Decodable {
    let account_id: Int?
    let hero_id: Int
    let item_0: Int
    let item_1: Int
    let item_2: Int
    let item_3: Int
    let item_4: Int
    let item_5: Int
    let level: Int
    let personaname: String?
    let win: Int
    let total_gold: Int
    let assists: Int
    let deaths: Int
    let kills: Int
    let isRadiant: Bool
}

struct GameMode: Decodable {
    let name: String
}

struct Item: Decodable {
    let img: String
}
