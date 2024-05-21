//
//  TabBarController.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 21.05.2024.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.items?[0].title = "Home"
        tabBar.items?[0].image = UIImage(systemName: "house.fill")
        tabBar.items?[1].title = "Favorites"
        tabBar.items?[1].image = UIImage(systemName: "star.fill")

    }

}
