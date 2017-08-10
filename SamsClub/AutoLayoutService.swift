//
//  AutoLayoutService.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit
class AutoLayoutService {
    static func pin(target view: UIView, to container: UIView, top: Double? = nil, right: Double? = nil, bottom: Double? = nil, left: Double? = nil) {
        if let top = top {
            view.topAnchor.constraint(equalTo: container.topAnchor, constant: CGFloat(top)).isActive = true
        }
        if let right = right {
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: CGFloat(right)).isActive = true
        }
        if let bottom = bottom {
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: CGFloat(bottom)).isActive = true
        }
        if let left = left {
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: CGFloat(left)).isActive = true
        }
    }
}
