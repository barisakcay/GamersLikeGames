//
//  UILabel+.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 23.05.2024.
//

import UIKit

public extension UIImageView {
    
    func edgeTo(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
    }
}
