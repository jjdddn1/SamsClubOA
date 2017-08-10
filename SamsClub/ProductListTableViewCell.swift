//
//  ProductListTableViewCell.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {
    // MARK: - properties
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var reviewNumLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var inStockLabel: UILabel!
    
    private var counter: Int32 = 0
    private var seperatorLayer: CALayer = CALayer()
    private let SEPERATOR_HEIGHT: CGFloat = 0.5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        seperatorLayer.backgroundColor = UIColor.black.cgColor
        self.layer.addSublayer(seperatorLayer)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        seperatorLayer.frame = CGRect(x: 0.0, y: self.frame.size.height - SEPERATOR_HEIGHT, width: self.frame.size.width, height: SEPERATOR_HEIGHT)
    }
    
    override func prepareForReuse() {
        OSAtomicIncrement32(&counter)
    }
    
    func populateCell(title: String?, rating: Double?, ratingCount: Int?, inStock: Bool?, price: String?, productImageUrl: URL?) {
        if let url = productImageUrl {
            let currentCount = counter
            ImageService.shared.downloadImageFrom(url: url) { [weak self] (image) in
                if currentCount != self?.counter {
                    return
                }
                DispatchQueue.main.async {
                    self?.thumbnailImageView.image = image
                }
            }
        }
        
        titleLable.text = title
        titleLable.sizeToFit()
        ratingView.setRating(rating: rating)
        if let count = ratingCount {
            reviewNumLabel.text = "\(count)"
        }
        priceLabel.text = price
        
        if let inStock = inStock, inStock {
            inStockLabel.text = "In Stock"
            inStockLabel.textColor = .green
        } else {
            inStockLabel.text = "Out of Stock"
            inStockLabel.textColor = .red
        }
    }
}
