//
//  LoadingTableViewCell.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
        backgroundColor = UIColor.scBackgroundGray
    }
}
