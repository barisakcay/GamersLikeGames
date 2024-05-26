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
    }
    
    func configure(with model: Games?) {
        
        guard let model else { return }
        imageView.kf.setImage(with: URL(string: model.backgroundImage), placeholder: UIImage(systemName: "hourglass.circle.fill"))
        titleLabel.text = model.name
        let stringRating = String(model.rating!)
        guard let released = model.released else { return }
        ratingReleasedLabel.text = "Rate: " + stringRating + " " + "Released Date: " + released
    }
}
