//
//  ProductItem.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import Foundation

struct ProductItem {
    ///Unique Id of the product
    var productId: String?
    
    /// Product Name
    var productName: String?
    
    /// Short Description of the product
    var shortDescription: String?
    
    /// Long Description of the product
    var longDescription: String?
    
    /// Product price
    var price: String?
    
    /// Image url for the product
    var productImageUrl: URL?
    
    /// Average review rating for the product
    var reviewRating: Double?
    
    /// Number of reviews
    var reviewCount: Int?
    
    /// Returns true if item in stock
    var inStock: Bool?
    
    init(dict: [String:Any]) {
        productId = dict["productId"] as? String
        productName = dict["productName"] as? String
        shortDescription = dict["shortDescription"] as? String
        longDescription = dict["longDescription"] as? String
        price = dict["price"] as? String
        if let imageUrlStr = dict["productImage"] as? String {
            productImageUrl = URL(string: imageUrlStr)
        }
        reviewRating = dict["reviewRating"] as? Double
        reviewCount = dict["reviewCount"] as? Int
        inStock = dict["inStock"] as? Bool
    }
}

extension ProductItem: Equatable {
    public static func ==(lhs: ProductItem, rhs: ProductItem) -> Bool {
        if lhs.productId == rhs.productId {
            return true
        }
        
        return false
    }
}
