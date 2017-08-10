//
//  ProductDetailDescriptionCell.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit

class ProductDetailDescriptionCell: UITableViewCell {
    @IBOutlet weak var descriptionView: UIWebView!
    func populateCell(description: String?) {
        guard let html = description else { return }
        descriptionView.loadHTMLString(html, baseURL: nil)
    }
}
