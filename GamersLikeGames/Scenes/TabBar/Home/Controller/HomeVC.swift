//
//  ViewController.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 20.05.2024.
//

import UIKit

final class HomeVC: UIViewController {

    //MARK: - OUTLETS

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    //MARK: - PROPERTIES
    
    private let viewModel = HomeVM()

    //MARK: - LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: Constants().homeListCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants().homeListCellIdentifier)
        topViewConfigure()
    }

    //MARK: - PRIVATE FUNCTIONS

    private func topViewConfigure() {
        let myView = UIImageView()
        myView.image = UIImage(systemName: "gamecontroller")
        myView.frame.size.height = 120
        myView.frame.size.width = 200
        myView.frame.origin.x = 10
        myView.frame.origin.y = 0
        let pageControl = UIPageControl(frame: CGRect(x: 100, y: 100, width: 80, height: 30))
        topView.backgroundColor = .cyan
        topView.addSubview(myView)
        topView.addSubview(pageControl)
    }
}

//MARK: - UICOLLECTIONVIEW DATASOURCE

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.resultsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().homeListCellIdentifier, for: indexPath) as? HomeListCell else { return UICollectionViewCell()}
        cell.configure()
        viewModel.getsGame(with: indexPath.row)
        return cell
    }
}
