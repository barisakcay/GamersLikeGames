//
//  DetailsVC.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 21.05.2024.
//

import UIKit
import Kingfisher

final class DetailsVC: UIViewController {

    var id = Int()
    private var viewModel = DetailsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.fetchData(with: Constants().gameDetailBaseURL + "\(id)?key=" + Constants().apiKey)
        
    }
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isDirectionalLockEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var gameNameLabel: UILabel = {
        let label = UILabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let name = self.viewModel.detail.first?.name else { return }
            label.text = name
        }
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var gameInfoLabel: UILabel = {
        let label = UILabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let releasedDate = self.viewModel.detail.first?.released else { return }
            guard let rate = self.viewModel.detail.first?.metacritic else { return }
            label.text = ("Released Date: \(String(releasedDate))\nMetacritic Rate: \(String(rate))")
        }
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.sizeToFit()
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var middleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var gameImage: UIImageView = {
        let image = UIImageView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            image.kf.setImage(
                with: URL(string: self.viewModel.detail[0].backgroundImage!),
                placeholder: UIImage(systemName: "hourglass.circle"))
        }
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            button.backgroundColor = .cyan
        }
        return button
    }()
    
    lazy var gameDescription: UILabel = {
        let label = UILabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            label.text = self.viewModel.detail.first?.description
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    func configureUI() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        configureTopView()
        configureMiddleView()
    }
    
    func configureTopView() {
        contentView.addSubview(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: contentView.topAnchor),
            topView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            topView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            topView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, constant: 150)
        ])
        topView.addSubview(gameNameLabel)
        NSLayoutConstraint.activate([
            gameNameLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 10),
            gameNameLabel.leftAnchor.constraint(equalTo: topView.leftAnchor),
            gameNameLabel.rightAnchor.constraint(equalTo: topView.rightAnchor),
            gameNameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        topView.addSubview(gameInfoLabel)
        NSLayoutConstraint.activate([
            gameInfoLabel.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor, constant: 8),
            gameInfoLabel.leftAnchor.constraint(equalTo: topView.leftAnchor),
            gameInfoLabel.rightAnchor.constraint(equalTo: topView.rightAnchor),
            gameInfoLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor)
        ])
    }
    
    func configureMiddleView() {
        contentView.addSubview(middleView)
        NSLayoutConstraint.activate([
            middleView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            middleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            middleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            middleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        middleView.addSubview(gameImage)
        NSLayoutConstraint.activate([
            gameImage.topAnchor.constraint(equalTo: middleView.topAnchor, constant: 10),
            gameImage.leftAnchor.constraint(equalTo: middleView.leftAnchor),
            gameImage.rightAnchor.constraint(equalTo: middleView.rightAnchor),
            gameImage.heightAnchor.constraint(equalToConstant: 240)
        ])
        gameImage.addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            favoriteButton.rightAnchor.constraint(equalTo: gameImage.rightAnchor,constant: -8),
            favoriteButton.bottomAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 60),
            favoriteButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        middleView.addSubview(gameDescription)
        NSLayoutConstraint.activate([
            gameDescription.topAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 10),
            gameDescription.leftAnchor.constraint(equalTo: middleView.leftAnchor),
            gameDescription.rightAnchor.constraint(equalTo: middleView.rightAnchor),
            gameDescription.bottomAnchor.constraint(equalTo: middleView.bottomAnchor)
            
        ])
    }
}
