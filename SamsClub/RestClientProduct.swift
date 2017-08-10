//
//  RestClientProduct.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit

class RestClientProduct {
    func getProductsList(at page: Int = 0, pageSize: Int = 20, success:((_ data: [String: Any]) -> ())?, failure: ((_ reponse: Any?, _ error: Error?) -> ())?) {
        let request = Request()
        request.successBlock = success
        request.failureBlock = failure
        
        let urlStr = BASE_URL + "/walmartproducts/" + API_KEY + "/\(page)/" + "\(pageSize)"
        guard let url = URL(string: urlStr) else { return }
        request.url = url
        
        request.performRequest()
    }
    
    
    /// take the data from get prodcuts list api, return total number of items, pageNum and list of product item
    ///
    /// - Parameter data: response data from get prodcuts list api call
    /// - Returns: total number of items, pageNum and list of product item
    func deserializeProductRequestResponse(data: [String: Any]) -> (Int, Int, [ProductItem]) {
        var result = (0, 0, [ProductItem]())
        if let count = data["totalProducts"] as? Int {
            result.0 = count
        }
        
        if let page = data["pageNumber"] as? Int {
            result.1 = page
        }
        
        if let items = data["products"] as? [[String: Any]] {
            result.2 = items.map({ (item) -> ProductItem in
                ProductItem.init(dict: item)
            })
        }
        
        return result
    }
    
}
