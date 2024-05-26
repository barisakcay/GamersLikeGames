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
    private var isSearching: Bool = false
    
    //MARK: - TOPVIEW ITEMS
    
    lazy var firstView: UIView = {
        let view = UIView()
        let imageView = UIImageView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            imageView.kf.setImage(
                with: URL(string: self.viewModel.getsGame(with: 0).backgroundImage),
                placeholder: UIImage(systemName: "hourglass.circle"))
        }
        view.addSubview(imageView)
        imageView.edgeTo(view)
        return view
    }()
    
    lazy var secondView: UIView = {
        let view = UIView()
        let imageView = UIImageView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            imageView.kf.setImage(
                with: URL(string: self.viewModel.getsGame(with: 1).backgroundImage),
                placeholder: UIImage(systemName: "hourglass.circle"))
        }
        view.addSubview(imageView)
        imageView.edgeTo(view)
        return view
    }()

    lazy var thirdView: UIView = {
        let view = UIView()
        let imageView = UIImageView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            imageView.kf.setImage(
                with: URL(string: self.viewModel.getsGame(with: 2).backgroundImage),
                placeholder: UIImage(systemName: "hourglass.circle"))
        }
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
        viewModel.fetchData(with: Constants().gameListURL)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.collectionView.reloadData()
        }
        topViewSetup()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.title = "GamersLikeGames"
    }

    //MARK: - PRIVATE FUNCTIONS

    private func topViewSetup() {
        topView.addSubview(scrollView)
        topView.addSubview(pageControl)
        pageControl.pinTo(topView)
        scrollView.edgeTo(view: topView)
    }
}

//MARK: - UICOLLECTIONVIEW DATASOURCE + UICOLLECTIONVIEW DELEGATEFLOWLAYOUT

extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            if viewModel.searchedResultsCount == 0 {
                self.collectionView.setEmptyMessage("Can't Find Anything :(")
                return 0
            } else {
                return viewModel.searchedResultsCount
            }
        } else {
            return viewModel.resultsCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants().homeListCellIdentifier, for: indexPath) as? HomeListCell else { return UICollectionViewCell()}
        if isSearching == false {
            cell.configure(with: viewModel.getsGame(with: indexPath.row))
        }else {
            cell.configure(with: viewModel.getSearchedGame(with: indexPath.row))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == (viewModel.resultsCount - 2)) && isSearching == false{
            self.viewModel.fetchData(with: Constants().gameListURL + "&page=\(self.pageNumber)")
            self.pageNumber += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 380, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: Constants().detailsViewIdentifier) as! DetailsVC
        if isSearching {
            detailVC.id = viewModel.getSearchedGame(with: indexPath.row).id!
        }else {
            detailVC.id = viewModel.getsGame(with: indexPath.row).id!
        }
        self.present(detailVC, animated: true)
    }
}

//MARK: - SCROLLVIEW DELEGATE

extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / topView.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

//MARK: - SEARCH BAR DELEGATE

extension HomeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.fetchSearchedData(with:Constants().gameListURL + "&search=\(searchText.lowercased())")
        if searchText != "" {
            isSearching = true
            topView.isHidden = true
            pageControl.isHidden = true
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
            ])
        } else {
            isSearching = false
            topView.isHidden = false
            NSLayoutConstraint.activate([
                topView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
                topView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
                topView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
                topView.heightAnchor.constraint(equalToConstant: 160),
            ])
            pageControl.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.collectionView.reloadData()
        }
    }
}
