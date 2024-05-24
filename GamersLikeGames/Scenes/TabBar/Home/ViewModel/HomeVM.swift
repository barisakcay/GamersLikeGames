//
//  HomeVM.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 21.05.2024.
//
import UIKit

final class HomeVM {
    
    //MARK: - PROPERTIES
    
    private var results: [Games] = []
    var resultsCount: Int { results.count }
    
    //MARK: - FETCHING GAME DATA
    
    func fetchData(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let safeData = data {
                if let games = self.parseJSON(safeData) {
                    for game in games {
                        self.results.append(game)
                    }
                }
            }
        }
        task.resume()
    }
    
    //MARK: - PARSING GAME DATA
    
    func parseJSON(_ gameData: Data) -> [Games]? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(GameModel.self, from: gameData)
            return decodedData.results
        } catch {
            print("Decode error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func getsGame(with: Int) -> Games {
        results[with]
    }
}
