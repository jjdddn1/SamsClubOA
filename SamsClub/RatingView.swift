//
//  RatingView.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit

class RatingView: UIView {
    var starImageViews: [UIImageView]

    // MARK: - init
    override init(frame: CGRect) {
        starImageViews = []
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        starImageViews = []
        super.init(coder: coder)!
        setup()
    }
    
    // MARK: - setup
    private func setup() {
        starImageViews += [createStartImageView(),
                           createStartImageView(),
                           createStartImageView(),
                           createStartImageView(),
                           createStartImageView()]
        let stackView = UIStackView.init(arrangedSubviews: starImageViews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5.0
        
        self.addSubview(stackView)
        AutoLayoutService.pin(target: stackView, to: self, top: 0.0, right: 0.0, bottom: 0.0, left: 0.0)
    }
    
    private func createStartImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.isOpaque = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "start_empty_icon")
        return imageView
    }
    
    func setRating(rating: Double?) {
        guard let rating = rating else {
            for imageView in starImageViews {
                imageView.image = #imageLiteral(resourceName: "star_half_icon")
            }
            return
        }
        
        let solidStarNum = Int(rating)
        if solidStarNum >= 1{
            for i in 1...solidStarNum {
                starImageViews[i - 1].image = #imageLiteral(resourceName: "star_icon")
            }
        }
        
        if solidStarNum == 5 {
            return
        }
        
        let restStar = rating - Double(solidStarNum)
        if restStar > 0.8 {
            starImageViews[solidStarNum].image = #imageLiteral(resourceName: "star_icon")
        } else if restStar > 0.3 {
            starImageViews[solidStarNum].image = #imageLiteral(resourceName: "star_half_icon")
        }
        
        if solidStarNum < 5 {
            for i in (solidStarNum + 1)...5 {
                starImageViews[i - 1].image = #imageLiteral(resourceName: "start_empty_icon")
            }
        }
    }
}
