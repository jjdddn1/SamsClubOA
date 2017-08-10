//
//  RestClient.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import Foundation

class Request {
    var successBlock: ((_ data: [String: Any]) -> ())?
    var failureBlock: ((_ reponse: Any?, _ error: Error?) -> ())?
    var url: URL?
    
    func performRequest() {
        guard let url = url else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                self.failureBlock?(response, error)
            } else {
                guard let data = data, let tmpJsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any], let jsonData = tmpJsonData else {
                    self.failureBlock?(response, error)
                    return
                }
                self.successBlock?(jsonData)
            }
        })
        
        task.resume()
    }
    
}
