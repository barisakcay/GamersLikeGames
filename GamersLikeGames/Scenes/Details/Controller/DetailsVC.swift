//
//  DetailsVC.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 21.05.2024.
//

import UIKit
import Kingfisher

final class DetailsVC: UIViewController {
    
    //MARK: - PROPERTIES
    
    var id = Int()
    var isFavorited = false
    private var viewModel = DetailsVM()
    
    //MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData(with: Constants().gameDetailBaseURL + "\(id)?key=" + Constants().apiKey)
        configureUI()
    }
    
    //MARK: - VIEW INITIALIZATIONS
    
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
            guard let imageString = self.viewModel.detail.first?.backgroundImage else { return }
            image.kf.setImage(
                with: URL(string: imageString),
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
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            button.configuration?.imagePadding = 50
            button.tintColor = .red
        }
        button.addTarget(self, action: #selector(favoriteButtonPressed(sender: )), for: .touchUpInside)
        return button
    }()
    
    lazy var gameDescription: UILabel = {
        let label = UILabel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let description = self.viewModel.detail.first?.description?.data(using: .utf8) {
                let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ]
                do {
                    let attributedString = try NSAttributedString(data: description, options: options, documentAttributes: nil)
                    let descriptionString = attributedString.string
                    label.text = descriptionString
                } catch {
                    print("Failed to convert HTML to plain string: \(error)")
                }
            }
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    //MARK: - FAVORITEBUTTON ACTION
    
    @objc func favoriteButtonPressed(sender: UIButton) {

        if favoriteButton.imageView?.image == UIImage(systemName: "heart") {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            viewModel.saveFavorite()
        } else {
            let refreshAlert = UIAlertController(title: "Remove", message: "This game will remove from favorites.", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(refreshAlert, animated: true, completion: nil)
        }
    }
    
    //MARK: - VIEW CONFUGURATION METHODS
    
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
        topView.addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            favoriteButton.rightAnchor.constraint(equalTo: topView.rightAnchor,constant: -8),
            favoriteButton.topAnchor.constraint(equalTo: topView.topAnchor, constant: 60),
            favoriteButton.widthAnchor.constraint(equalToConstant: 54),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor)
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
            gameImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            gameImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            gameImage.heightAnchor.constraint(equalToConstant: 240)
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
