//
//  StorageManager.swift
//  DotaStatisticsApp
//
//  Created by MAC  on 15.06.2023.
//

import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoritePlayers")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Storage Manager functions
    func fetchData(completion: (Result<[FavoritePlayer], Error>) -> Void) {
        let fetchRequest = FavoritePlayer.fetchRequest()
        
        do {
            let favoritePlayers = try self.viewContext.fetch(fetchRequest)
            completion(.success(favoritePlayers))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func create(id: Int, name: String, image: String) {
        let favoritePlayer = FavoritePlayer(context: viewContext)
        favoritePlayer.accountId = Int32(id)
        favoritePlayer.personaName = name
        favoritePlayer.avatarImage = image
        saveContext()
    }
    
    func delete(favoritePlayer: FavoritePlayer) {
        viewContext.delete(favoritePlayer)
        saveContext()
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
