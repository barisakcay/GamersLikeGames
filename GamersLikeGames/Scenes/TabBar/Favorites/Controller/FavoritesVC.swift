//
//  FavoritesVC.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 21.05.2024.
//

import UIKit

final class FavoritesVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - PROPERTIES
    
    private var viewModel = FavoritesVM()
    
    //MARK: - LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: Constants().favoritesCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants().favoritesCellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadItems()
        collectionView.reloadData()
    }
}

//MARK: - COLLECTIONVIEW DATASOURCE + DELEGATE METHODS

extension FavoritesVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.favoritedItems.count == 0 {
            self.collectionView.setEmptyMessage("There is no favorited game here!")
            return 0
        } else {
            return viewModel.favoritedItems.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().favoritesCellIdentifier, for: indexPath) as? FavoritesCell else { return UICollectionViewCell() }
        cell.configure(with: viewModel.favoritedItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: Constants().detailsViewIdentifier) as! DetailsVC
        detailVC.id = viewModel.favoritedItems[indexPath.row].id!
        self.present(detailVC, animated: true)
    }
}
