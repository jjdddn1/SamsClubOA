//
//  ProductDetailTableViewController.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit

class ProductDetailTableViewController: UITableViewController {
    enum ProductDetailTableCellType: Int {
        case image
        case title
        case price
        case description
        case total
    }
    
    /// If no, the image cell will be left blank
    var shouldPopulateThumbnailCell = true
    
    /// product item data
    var item: ProductItem?
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - setup
    private func setupUI() {
        tableView.separatorStyle = .none
        tableView.register(UINib.init(nibName: "ProductDetialTitleCell", bundle: nil) , forCellReuseIdentifier: NSStringFromClass( ProductDetialTitleCell.self))
        tableView.register(UINib.init(nibName: "ProductDetailPriceCell", bundle: nil) , forCellReuseIdentifier: NSStringFromClass(ProductDetailPriceCell.self))
        tableView.register(UINib.init(nibName: "ProductDetailDescriptionCell", bundle: nil) , forCellReuseIdentifier: NSStringFromClass(ProductDetailDescriptionCell.self))
        tableView.register(UINib.init(nibName: "ProductDetailImageCell", bundle: nil) , forCellReuseIdentifier: NSStringFromClass(ProductDetailImageCell.self))

    }
}

    // MARK: - Table view data source
    extension ProductDetailTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductDetailTableCellType.total.rawValue
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = ProductDetailTableCellType(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        var cell: UITableViewCell? = nil
        switch type {
        case .image:
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ProductDetailImageCell.self))
            if shouldPopulateThumbnailCell {
                (cell as! ProductDetailImageCell).populateCell(imageUrl: item?.productImageUrl)
            }
        case .title:
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ProductDetialTitleCell.self))
            (cell as! ProductDetialTitleCell).populateCell(title: item?.productName, rating: item?.reviewRating, ratingCount: item?.reviewCount, inStock: item?.inStock)
        case .price:
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ProductDetailPriceCell.self))
            (cell as! ProductDetailPriceCell).populateCell(price: item?.price)
            
        case .description:
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ProductDetailDescriptionCell.self))
            (cell as! ProductDetailDescriptionCell).populateCell(description: item?.shortDescription)
        default:
            cell = UITableViewCell()
        }
         
        // Configure the cell...
        cell!.selectionStyle = .none
        return cell!
    }
        
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let type = ProductDetailTableCellType(rawValue: indexPath.row) else {
            return 0.0
        }
        switch type {
        case .title, .price, .description:
            return UITableViewAutomaticDimension
        case .image:
            return 200
        default:
            return 0.0
        }
    }
        
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

}
