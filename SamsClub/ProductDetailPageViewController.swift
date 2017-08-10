//
//  ProductDetailPageViewController.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit

protocol ProductDetailPageViewDataSource: class {
    func productDetailPageView(productDetailPageView: ProductDetailPageViewController, productItemBefore productItem: ProductItem) -> ProductItem?
    func productDetailPageView(productDetailPageView: ProductDetailPageViewController, productItemAfter productItem: ProductItem) -> ProductItem?
}

protocol ProductDetailPageViewDelegate: class {
    func productDetailPageView(productDetailPageView: ProductDetailPageViewController, didShowProductItem productItem: ProductItem)
}

class ProductDetailPageViewController: UIViewController {
    weak var dataSource: ProductDetailPageViewDataSource?
    weak var delegate:ProductDetailPageViewDelegate?
    
    /// The product data for the first child VC
    var initialItem: ProductItem?
    
    lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return pageViewController
    }()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - set up
    private func setupUI() {
        view.backgroundColor = UIColor.white
        setupNavBar()
        
        // Set up Page View Controller
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        AutoLayoutService.pin(target: pageViewController.view, to: self.view, top: 64.0, right: 0.0, bottom: 0.0, left: 0.0)
        
        let initialVC = ProductDetailTableViewController()
        initialVC.item = initialItem
        pageViewController.setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.scBlue
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.topViewController?.title = "Item Detail"
    }
}

// MARK: - UIPageViewControllerDataSource & UIPageViewControllerDelegate
extension ProductDetailPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let item = (pageViewController.viewControllers?.first as! ProductDetailTableViewController).item, let newItem = dataSource?.productDetailPageView(productDetailPageView: self, productItemAfter: item) {
            let vc = ProductDetailTableViewController()
            vc.item = newItem
            return vc
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let item = (pageViewController.viewControllers?.first as! ProductDetailTableViewController).item, let newItem = dataSource?.productDetailPageView(productDetailPageView: self, productItemBefore: item) {
            let vc = ProductDetailTableViewController()
            vc.item = newItem
            return vc
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished, completed, let item = (pageViewController.viewControllers?.first as! ProductDetailTableViewController).item {
            delegate?.productDetailPageView(productDetailPageView: self, didShowProductItem: item)
        }
    }
}
