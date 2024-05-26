//
//  DetailsVM.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 21.05.2024.
//

import UIKit
import CoreData

final class DetailsVM {
    
    var detail: [GameDetailModel] = []
    
    func fetchData(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let safeData = data {
                if let result = self.parseJson(safeData) {
                    self.detail.append(result)
                }
            }
        }
        task.resume()
    }
    
    func parseJson(_ detailData: Data) -> GameDetailModel? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(GameDetailModel.self, from: detailData)
            return decodedData
        } catch {
            print("Game Detail Decode Error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func saveFavorite() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let newGame = NSEntityDescription.insertNewObject(forEntityName: "Favorited", into: context)
        newGame.setValue(detail.first?.name!, forKey: "name")
        newGame.setValue(detail.first?.id!, forKey: "id")
        newGame.setValue(detail.first?.released!, forKey: "released")
        newGame.setValue(detail.first?.backgroundImage!, forKey: "backgroundImage")
        
        do {
            try context.save()
        } catch {
            print("Data save error \(error.localizedDescription)")
        }
    }
    
//    func deleteFavorite() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//        
//        let newGame = NSEntityDescription.insertNewObject(forEntityName: "Favorited", into: context)
//        newGame.setValue(detail.first?.name!, forKey: "name")
//        newGame.setValue(detail.first?.id!, forKey: "id")
//        newGame.setValue(detail.first?.released!, forKey: "released")
//        newGame.setValue(detail.first?.backgroundImage!, forKey: "backgroundImage")
//
//        conte
//    }
}
