//
//  HomeVM.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 21.05.2024.
//

struct HomeVM {
    
    private var results: [Games] = []
    var resultsCount: Int { results.count }
    
    func fetchData() {
        
    }
    
    func getsGame(with: Int) -> Games {
        results[with]
    }
}
