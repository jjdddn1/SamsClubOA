//
//  ProductDetailPriceCell.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit

class ProductDetailPriceCell: UITableViewCell {
    @IBOutlet weak var priceLabel: UILabel!

    func populateCell(price: String?) {
        priceLabel.text = price
    }
}
