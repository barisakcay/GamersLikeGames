//
//  FavoritesVC.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 21.05.2024.
//

import UIKit

final class FavoritesVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = FavoritesVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: Constants().favoritesCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants().favoritesCellIdentifier)
        viewModel.loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
//        if viewModel.favoritedItems.isEmpty {
//            let emptyView = UIView()
//            emptyView.backgroundColor = .blue
//            emptyView.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(emptyView)
//            emptyView.pinTo(view)
//        }
    }
}

extension FavoritesVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoritedItems.count
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
