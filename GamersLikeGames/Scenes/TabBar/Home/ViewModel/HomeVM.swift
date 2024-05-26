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
    private var searchResults: [Games] = []
    var resultsCount: Int { results.count }
    var searchedResultsCount: Int { searchResults.count }
    
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
    
    //MARK: - FETCHING SEARCHING DATA
    
    func fetchSearchedData(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let safeData = data {
                if let games = self.parseJSON(safeData) {
                    self.searchResults = games
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
        if resultsCount != 0 {
            return results[with]
        }
        return Games(id: 1, name: "No Name", released: "No Time", rating: 0.0, backgroundImage: "https://media.rawg.io/media/games/46d/46d98e6910fbc0706e2948a7cc9b10c5.jpg")
    }
    
    func getSearchedGame(with: Int) -> Games {
        if searchedResultsCount != 0 {
            return searchResults[with]
        }
        return Games(id: 1, name: "Can't found game!", released: "", rating: 0.0, backgroundImage: "https://media.rawg.io/media/games/46d/46d98e6910fbc0706e2948a7cc9b10c5.jpg")
    }
}
