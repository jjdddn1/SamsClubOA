//
//  NavAnimator.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit

class NavPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var ANIMATION_DURATION = 0.25
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ANIMATION_DURATION
    }
    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        guard let detailVC = context.viewController(forKey: UITransitionContextViewControllerKey.to) as? ProductDetailPageViewController,
            let listVC = context.viewController(forKey: UITransitionContextViewControllerKey.from) as? ProductListTableViewController else {
                return
        }
        
        context.containerView.addSubview(detailVC.view)

        // create a new imageView
        let imageView = UIImageView()
        imageView.frame = listVC.selectedCellImageOnScreeFrame!
        ImageService.shared.downloadImageFrom(url: listVC.selectedCellData.productImageUrl) { (image) in
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
        
        let coverView = addCoverImage(listVC: listVC)
        UIApplication.shared.keyWindow?.addSubview(imageView)
        
        let childVC = detailVC.pageViewController.viewControllers?.first as! ProductDetailTableViewController
        childVC.tableView.alpha = 0.0
        childVC.shouldPopulateThumbnailCell = false
        detailVC.view.alpha = 0.0
        
        UIView.animate(withDuration: self.ANIMATION_DURATION, delay: 0.0, options: .curveLinear, animations: {
            imageView.frame = CGRect(x: (UIScreen.main.bounds.width - 200.0) / 2, y: 64.0, width: 200.0, height: 200.0)
        }, completion: { _ in
            imageView.removeFromSuperview()
            coverView.removeFromSuperview()
            imageView.frame = CGRect(x: (UIScreen.main.bounds.width - 200.0) / 2, y: 0.0, width: 200.0, height: 200.0)
            childVC.tableView.addSubview(imageView)
            context.completeTransition(!context.transitionWasCancelled)
        })
        
        UIView.animate(withDuration: 0.15, animations: {
            detailVC.view.alpha = 1
        }) { _ in
            UIView.animate(withDuration: self.ANIMATION_DURATION - 0.15, animations: {
                childVC.tableView.alpha = 1
            }, completion:nil)
        }
    }
}

class NavPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var ANIMATION_DURATION = 0.25
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ANIMATION_DURATION
    }
    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        guard let detailVC = context.viewController(forKey: UITransitionContextViewControllerKey.from) as? ProductDetailPageViewController,
            let listVC = context.viewController(forKey: UITransitionContextViewControllerKey.to) as? ProductListTableViewController else {
                return
        }
        
        context.containerView.addSubview(listVC.view)
        context.containerView.sendSubview(toBack: listVC.view)
        let childVC = detailVC.pageViewController.viewControllers?.first as! ProductDetailTableViewController
        
        // create a new imageView
        let largeImageViewFrame = CGRect(x: (UIScreen.main.bounds.width - 200.0) / 2, y: 64.0 - childVC.tableView.contentOffset.y, width: 200.0, height: 200.0)
        
        let imageView = UIImageView()
        imageView.frame = largeImageViewFrame
        ImageService.shared.downloadImageFrom(url: listVC.selectedCellData.productImageUrl) { (image) in
            DispatchQueue.main.async {
                imageView.image = image
            }
        }
        UIApplication.shared.keyWindow?.addSubview(imageView)
        
        let coverView = addCoverImage(listVC: listVC)
        
        UIView.animate(withDuration: self.ANIMATION_DURATION, delay: 0.0, options: .curveLinear, animations: {
            imageView.frame = listVC.selectedCellImageOnScreeFrame!
        }, completion: { _ in
            imageView.removeFromSuperview()
            coverView.removeFromSuperview()
            
            detailVC.removeFromParentViewController()
            context.completeTransition(!context.transitionWasCancelled)
        })
        
        UIView.animate(withDuration: self.ANIMATION_DURATION - 0.2, animations: {
            childVC.tableView.alpha = 0
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                detailVC.view.alpha = 0
            }, completion:nil)
        }
    }
}

fileprivate func addCoverImage(listVC: ProductListTableViewController) -> UIView {
    let coverView = UIView() // a white cover view over table Cell thumbnail
    coverView.frame = listVC.selectedCellImageOnTableFrame!
    coverView.frame.origin.y -= 64.0
    coverView.backgroundColor = .white
    listVC.view.addSubview(coverView)
    return coverView
}
