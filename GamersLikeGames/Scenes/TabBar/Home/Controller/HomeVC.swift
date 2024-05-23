//
//  HomeVC.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 20.05.2024.
//

import UIKit
import Kingfisher

final class HomeVC: UIViewController {
    
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    //MARK: - PROPERTIES
    
    private var viewModel = HomeVM()
    private var pageNumber = 2
    
    //MARK: - TOPVIEWITEMS
    
    lazy var firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemTeal
        let imageView = UIImageView()
//        imageView.kf.setImage(with: URL(string: viewModel.getsGame(with: 1).backgroundImage))
        view.addSubview(imageView)
        imageView.edgeTo(view)
        return view
        
    }()
    lazy var secondView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemYellow
        let imageView = UIImageView()
//        imageView.kf.setImage(with: URL(string: viewModel.getsGame(with: 2).backgroundImage))
        view.addSubview(imageView)
        imageView.edgeTo(view)
        return view
    }()
    lazy var thirdView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        let imageView = UIImageView()
//        imageView.kf.setImage(with: URL(string: viewModel.getsGame(with: 3).backgroundImage))
        view.addSubview(imageView)
        imageView.edgeTo(view)
        return view
    }()
    
    lazy var views = [firstView, secondView, thirdView]
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: topView.frame.width * CGFloat(views.count), height: topView.frame.height)
        scrollView.layer.cornerRadius = 20
        scrollView.clipsToBounds = true
        
        for i in 0..<views.count {
            scrollView.addSubview(views[i])
            views[i].frame = CGRect(x: topView.frame.width * CGFloat(i), y: 0, width: topView.frame.width, height: topView.frame.height)
        }
        
        scrollView.delegate = self
        
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = views.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender: )), for: .touchUpInside)
        return pageControl
    }()
    
    
    
    @objc func pageControlTapHandler(sender: UIPageControl) {
        scrollView.scrollTo(horizontalPage: sender.currentPage, animated: true)
    }
    
    
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: Constants().homeListCellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants().homeListCellIdentifier)
        topViewConfigure()
        topView.addSubview(scrollView)
        topView.addSubview(pageControl)
        pageControl.pinTo(topView)
        scrollView.edgeTo(view: topView)
        viewModel.fetchData(with: Constants().gameListURL)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    //MARK: - PRIVATE FUNCTIONS
    
    private func topViewConfigure() {
        
        
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

extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / topView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
