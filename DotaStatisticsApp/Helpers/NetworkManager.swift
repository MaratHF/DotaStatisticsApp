//
//  NetworkManager.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 06.06.2023.
//

import Foundation
import UIKit

enum NetworkError: String, Error {
    case invalidURL = "Invalid URL"
    case noData = "No data"
    case decodingError = "Decoding error"
}

enum UrlPath: String {
    case scheme = "https"
    case host = "api.opendota.com"
    case baseUrl = "https://api.opendota.com"
    case searchNamePath = "/api/search"
    case searchNameQuery = "q"
    case playerIdPath = "/api/players/"
    case playerMatchesPath = "/matches"
    case allMatchesPath = "/api/matches/"
    case allHeroesPath = "/api/heroStats"
    case favoriteHeroesPath = "/heroes"
    case totalsPath = "/totals"
    case winLosePath = "/wl"
    case gameModePath =  "/api/constants/game_mode"
    case itemIdsPath = "/api/constants/item_ids"
    case itemsPath = "/api/constants/items"
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private let session = URLSession.shared
    
    private init() {}
    
    func fetch<T: Decodable>(dataType: T.Type, from url: URL?, completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = url else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let type = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(type))
                    }
                } catch {
                    completion(.failure(NetworkError.decodingError))
                }
            } else {
                completion(.failure(NetworkError.noData))
            }
        }.resume()
    }
    
    func fetchImage(from url: String?, with completion: @escaping(Data) -> Void) {
        guard let stringURL = url else { return }
        guard let imageURL = URL(string: stringURL) else {
            print(NetworkError.invalidURL)
            return
        }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: imageURL) else {
                print(NetworkError.noData)
                return
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
}
