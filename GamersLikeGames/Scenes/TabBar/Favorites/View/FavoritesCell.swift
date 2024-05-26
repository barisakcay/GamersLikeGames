//
//  FavoritesCell.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 23.05.2024.
//

import UIKit

class FavoritesCell: UICollectionViewCell {

    @IBOutlet weak var addedDateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cellView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func configure(with model: Games?) {
        
        guard let model else { return }
        imageView.kf.setImage(with: URL(string: model.backgroundImage), placeholder: UIImage(systemName: "hourglass.circle.fill"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12/57 * imageView.frame.height
        nameLabel.text = model.name
        guard let released = model.released else { return }
        addedDateLabel.text = ("Released Date: \(released)")
    }
}
