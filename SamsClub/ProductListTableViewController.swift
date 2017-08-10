//
//  ProductListTableViewController.swift
//  SamsClub
//
//  Created by Huiyuan Ren on 8/9/17.
//  Copyright © 2017 Huiyuan Ren. All rights reserved.
//

import UIKit

class ProductListTableViewController: UITableViewController {
    // MARK: - properties
    
    /// data for the product item
    fileprivate(set) var itemData: [ProductItem] = []
    
    /// if all the data items have been fetched
    private var allDataFetched = false
    
    fileprivate var page: Int = 0
    private let pageSize: Int = 20
    fileprivate var isEndOfList = false
    
    /// the selectedCell
    fileprivate var selectedCellIndex: Int = 0
    /// return the frame of the image View
    var selectedCellImageOnScreeFrame: CGRect?
    var selectedCellImageOnTableFrame: CGRect?
    
    var selectedCellData: ProductItem {
        return itemData[selectedCellIndex]
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - setup
    private func setupUI() {
        setupNavBar()
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.scBackgroundGray
        tableView.register(UINib.init(nibName: "ProductListTableViewCell", bundle: nil) , forCellReuseIdentifier: NSStringFromClass( ProductListTableViewCell.self))
        tableView.register(UINib.init(nibName: "LoadingTableViewCell", bundle: nil) , forCellReuseIdentifier: NSStringFromClass( LoadingTableViewCell.self))
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.scBlue
        
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.topViewController?.title = "Sam's Club"
        navigationController?.delegate = self
    }
    
    // MARK: - helper 
    fileprivate func sendRequest(page: Int) {
        let client = RestClientProduct()
        client.getProductsList(at: page,
                               pageSize: pageSize,
                               success: { [weak self] (data) in
                                let data = client.deserializeProductRequestResponse(data: data)
                                if data.1 == self?.page {
                                    self?.page = data.1 + 1
                                    let size = min(data.2.count, data.0 - (self?.itemData.count ?? 0))
                                    for i in 0..<size {
                                        self?.itemData.append(data.2[i])
                                    }
                                    if self?.itemData.count == data.0 {
                                        self?.isEndOfList = true
                                    }
                                    DispatchQueue.main.async {
                                        self?.tableView.reloadData()
                                    }
                                }
            },
                               failure: nil)
    }
    
    fileprivate func segueToDetailPage() {
        let pageVC = ProductDetailPageViewController()
        pageVC.initialItem = selectedCellData
        pageVC.dataSource = self
        pageVC.delegate = self
        self.navigationController?.pushViewController(pageVC, animated: true)
    }
    
    fileprivate func setSelectedCellInformation(for indexPath: IndexPath) {
        selectedCellIndex = indexPath.row
        
        let rectOfCell = tableView.rectForRow(at: indexPath)
        selectedCellImageOnTableFrame = CGRect(x: 8.0, y: rectOfCell.origin.y + rectOfCell.size.height / 2 - 50.0 + 64.0, width: 90.0, height: 90.0)
        
        let rectOfCellInSuperview = CGRect(x: rectOfCell.origin.x - tableView.contentOffset.x, y: rectOfCell.origin.y - tableView.contentOffset.y, width: rectOfCell.size.width, height: rectOfCell.size.height)
        selectedCellImageOnScreeFrame = CGRect(x: 8.0, y: rectOfCellInSuperview.origin.y + rectOfCell.size.height / 2 - 50.0 + 64.0, width: 90.0, height: 90.0)
    }
}

// MARK: - Table view delegat & data source
extension ProductListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemData.count + (isEndOfList ? 0 : 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        if !isEndOfList && indexPath.row == itemData.count {
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(LoadingTableViewCell.self), for: indexPath)
            (cell as! LoadingTableViewCell).activityIndicator.startAnimating()
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ProductListTableViewCell.self), for: indexPath)
            let data = itemData[indexPath.row]
            (cell as! ProductListTableViewCell).populateCell(title: data.productName, rating: data.reviewRating, ratingCount: data.reviewCount, inStock: data.inStock, price: data.price, productImageUrl: data.productImageUrl)
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !isEndOfList && indexPath.row == itemData.count {
            sendRequest(page: page)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isEndOfList && indexPath.row == itemData.count {
            return
        }
        
        setSelectedCellInformation(for: indexPath)
        segueToDetailPage()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

// MARK: - UINavigationControllerDelegate
extension ProductListTableViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return NavPushAnimator()
        } else if operation == .pop {
            return NavPopAnimator()
        }
        
        return nil
    }
}


// MARK: - ProductDetailPageViewDataSource && ProductDetailPageViewDelegate
extension ProductListTableViewController: ProductDetailPageViewDataSource, ProductDetailPageViewDelegate {
    func productDetailPageView(productDetailPageView: ProductDetailPageViewController, productItemBefore productItem: ProductItem) -> ProductItem? {
        let index = itemData.index(of: productItem)
        if let index = index, index > 0 {
            return itemData[index - 1]
        }
        return nil
    }
    
    func productDetailPageView(productDetailPageView: ProductDetailPageViewController, productItemAfter productItem: ProductItem) -> ProductItem? {
        let index = itemData.index(of: productItem)
        if let index = index, index < itemData.count - 1 {
            return itemData[index + 1]
        }
        
        return nil
    }
    
    func productDetailPageView(productDetailPageView: ProductDetailPageViewController, didShowProductItem productItem: ProductItem) {
        guard let index = itemData.index(of: productItem) else {
            assert(false, "can't find productItem, something's wrong!")
        }
        setSelectedCellInformation(for: IndexPath(row: index, section: 0))
    }
}
