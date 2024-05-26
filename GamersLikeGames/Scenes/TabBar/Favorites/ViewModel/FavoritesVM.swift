//
//  FavoritesVM.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 21.05.2024.
//

import UIKit
import CoreData

final class FavoritesVM {
    
    var favoritedItems: [Games] = []
    
    func loadItems() {
        favoritedItems = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorited")
        
        do {
            let results = try context.fetch(fetchRequest)
            if !results.isEmpty {
                for result in results as! [NSManagedObject] {
                    guard let name = result.value(forKey: "name") as? String else { return }
                    guard let id = result.value(forKey: "id") as? Int else { return }
                    guard let backgroundImage = result.value(forKey: "backgroundImage") as? String else { return }
                    guard let released = result.value(forKey: "released") as? String else { return }
                    let rating = Float(1)
                    favoritedItems.append(Games(id: id, name: name, released: released, rating: rating, backgroundImage: backgroundImage))
                }
            }
        } catch {
            print("Favorited Items Fetching Error: \(error.localizedDescription)")
        }
    }
}
