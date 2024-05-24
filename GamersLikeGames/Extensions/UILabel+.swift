//
//  UILabel+.swift
//  GamersLikeGames
//
//  Created by Baris Akcay on 24.05.2024.
//

import Foundation

import UIKit

public extension UILabel {
    
    func edgeTo(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12).isActive = true
    }
}
