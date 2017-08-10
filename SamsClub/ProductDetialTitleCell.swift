//
//  ProductDetialTitleCell.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit

class ProductDetialTitleCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var inStockLabel: UILabel!
    
    func populateCell(title: String?, rating: Double?, ratingCount: Int?, inStock: Bool?) {
        if let title = title {
            titleLabel.text = title
        }
        ratingView.setRating(rating: rating)
        if let ratingCount = ratingCount {
            ratingCountLabel.text = "\(ratingCount)"
        }
        if let inStock = inStock, inStock {
            inStockLabel.text = "In Stock"
            inStockLabel.textColor = .green
        } else {
            inStockLabel.text = "Out of Stock"
            inStockLabel.textColor = .red
        }
        
    }
}
