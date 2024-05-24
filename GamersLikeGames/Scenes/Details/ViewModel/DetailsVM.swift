//
//  DetailsVM.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 21.05.2024.
//

import Foundation

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
}
