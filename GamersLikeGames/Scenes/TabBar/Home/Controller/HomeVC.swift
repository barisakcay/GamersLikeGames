//
//  HomeVC.swift
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
    
    private var viewModel = HomeVM()
    private var pageNumber = 2
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: Constants().homeListCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants().homeListCellIdentifier)
        topViewConfigure()
        viewModel.fetchData(with: Constants().gameListURL)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    //MARK: - PRIVATE FUNCTIONS
    
    private func topViewConfigure() {
        let myView = UIImageView()
        let secondGameImage = UIImageView()
        let thirdGameImage = UIImageView()
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

//MARK: - UICOLLECTIONVIEW DATASOURCE + UICOLLECTIONVIEWDELEGATEFLOWLAYOUT

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.resultsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().homeListCellIdentifier, for: indexPath) as? HomeListCell else { return UICollectionViewCell()}
        cell.configure(with: viewModel.getsGame(with: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == (viewModel.resultsCount - 2)) {
            self.viewModel.fetchData(with: Constants().gameListURL + "&page=\(self.pageNumber)")
            sleep(3)
            self.pageNumber += 1
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 380, height: 80)
    }
    
}
