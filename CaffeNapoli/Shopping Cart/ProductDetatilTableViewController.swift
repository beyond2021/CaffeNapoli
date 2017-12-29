//
//  ProductDetatilTableViewController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/26/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
class ProductDetatilTableViewController: UITableViewController {
    let shoeDetailCell = "shoeDetailCell"
    let buyButtonCell = "buyButtonCell"
    let productDetailCell = "productDetailCell"
    let suggestionCell = "suggestionCell"
    let suggestionCollectionViewCell = "suggestionCollectionViewCell"
    var product: Product?
    //
    
    let headerView: ProductImagesHeaderView = {
        let hv = ProductImagesHeaderView()
        hv.frame = CGRect(x: 0, y: 0, width: 375, height: 533)

        return hv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = product?.name
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableHeaderView = headerView
//        headerView.anchor(top: self.tableView.tableHeaderView?.topAnchor, left: self.tableView.tableHeaderView?.leftAnchor, bottom: self.tableView.tableHeaderView?.bottomAnchor, right: self.tableView.tableHeaderView?.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 533)
        
        
//        view.backgroundColor = .red
        //
        tableView.register(ShoeDetailCell.self, forCellReuseIdentifier:shoeDetailCell)
        tableView.register(BuyButtonCell.self, forCellReuseIdentifier: buyButtonCell)
        tableView.register(ProductDetailCell.self, forCellReuseIdentifier: productDetailCell)
        tableView.register(SuggestionCell.self, forCellReuseIdentifier: suggestionCell)
//        tableView.register(SuggestionCollectionViewCell.self, forCellReuseIdentifier: suggestionCollectionViewCell)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return self.tableView.bounds.width + 68
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    /*
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ProductImagesHeaderView()
        headerView.backgroundColor = UIColor.red
        return headerView
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 533
    }
    
   */
    
    
    
}

extension ProductDetatilTableViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 0 - shoe detail cell
        // 1 - buy button
        // 2 - shoe full details button cell
        // 3 - you might like this cell
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: shoeDetailCell, for: indexPath) as! ShoeDetailCell
            cell.product = product
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: buyButtonCell, for: indexPath) as! BuyButtonCell
            
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: productDetailCell, for: indexPath) as! ProductDetailCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: suggestionCell, for: indexPath) as! SuggestionCell
            
            return cell
        }
        
}
    //
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        
        
        if indexPath.row == 3 {
            if let cell = cell as? SuggestionCell {
                cell.suggestionCollectionView.register(SuggestionCollectionViewCell.self, forCellWithReuseIdentifier: "suggestionCollectionViewCell")
                
                cell.suggestionCollectionView.dataSource = self
                cell.suggestionCollectionView.delegate = self
                cell.suggestionCollectionView.reloadData()
                cell.suggestionCollectionView.isScrollEnabled = false
            }
        }
    }
    
    
}

// MARK: - UICollectionViewDataSource

extension ProductDetatilTableViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestionCollectionViewCell", for: indexPath) as! SuggestionCollectionViewCell
        let products = Product.fetchShoes()
        cell.image = products[indexPath.item].images?.first
        
        return cell
    }
    
}

extension ProductDetatilTableViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 5.0
        layout.minimumInteritemSpacing = 2.5
        let itemWidth = (collectionView.bounds.width - 5.0) / 2.0
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
