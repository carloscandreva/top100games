//
//  CollectionViewCell.swift
//  top100games
//
//  Created by Carlos Alberto Mota Candreva on 23/07/2018.
//  Copyright © 2018 Carlos Alberto Mota Candreva. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var gameImage: UIImageView!
    @IBOutlet var gameLabel: UILabel!
    
    func diplayContent(image: UIImage, title: String) {
        self.gameImage.image = image
        self.gameLabel.text = title
    }
}
