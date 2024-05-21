//
//  HomeListCell.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 21.05.2024.
//

import UIKit
import Kingfisher

class HomeListCell: UICollectionViewCell {

    @IBOutlet weak var ratingReleasedLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure() {
        imageView.image = UIImage(systemName: "gamecontroller.fill")
        titleLabel.text = "Grand Theft Auto V"
        ratingReleasedLabel.text = "4.47" + "2013-09-17"
    }
}
