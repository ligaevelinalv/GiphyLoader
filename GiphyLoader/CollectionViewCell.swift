//
//  CollectionViewCell.swift
//  GiphyLoader
//
//  Created by liga.evelina.liepina on 20/05/2020.
//  Copyright © 2020 liga.evelina.liepina. All rights reserved.
//

import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 10
    }

    func getURL(gifURL: URL) {
        gifImageView.kf.indicatorType = .activity
        self.gifImageView.kf.setImage(with: gifURL, options: [.transition(.fade(0.2))])
    }
}
