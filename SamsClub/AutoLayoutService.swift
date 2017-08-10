//
//  AutoLayoutService.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit
class AutoLayoutService {
    static func pin(target view: UIView, to container: UIView, top: CGFloat? = nil, right: CGFloat? = nil, bottom: CGFloat? = nil, left: CGFloat? = nil) {
        if let top = top {
            view.topAnchor.constraint(equalTo: container.topAnchor, constant: top).isActive = true
        }
        if let right = right {
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: right).isActive = true
        }
        if let bottom = bottom {
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: bottom).isActive = true
        }
        if let left = left {
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: left).isActive = true
        }
    }
}
