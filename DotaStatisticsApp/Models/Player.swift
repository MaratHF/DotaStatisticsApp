//
//  Player.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 07.06.2023.
//

import Foundation

struct Player: Decodable {
    let rank_tier: Int?
    let profile: Profile
}

struct Profile: Decodable {
    let account_id: Int
    let personaname: String?
    let avatarfull: String?
}

struct WinLose: Decodable {
    let win: Int
    let lose: Int
}

struct PlayerTotals: Decodable {
    let field: String
    let sum: Double
}

struct Summary {
    var rankTier: Int?
    var playerTotals: [PlayerTotals]?
    var matchesCount: Int?
    var winLose: WinLose?
}

struct PlayerMatch: Decodable {
    let match_id: Int
    let player_slot: Int
    let radiant_win: Bool
    let game_mode: Int
    let start_time: Int
    let duration: Int
    let account_id: Int?
    let hero_id: Int
    let kills: Int
    let deaths: Int
    let assists: Int
}
