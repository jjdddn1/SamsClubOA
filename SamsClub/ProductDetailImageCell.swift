//
//  ProductDetailImageCell.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit

class ProductDetailImageCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!

    func populateCell(imageUrl: URL?) {
        ImageService.shared.downloadImageFrom(url: imageUrl) { [weak self] (image) in
            DispatchQueue.main.async {
                self?.thumbnailImageView.image = image
            }
        }
    }
}
