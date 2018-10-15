//
//  ShoppingBagTableViewController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/31/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit



class ShoppingBagTableViewController: UITableViewController, CheckoutButtonCellDelegate {
    func didBuyProduct(for cell: CheckoutButtonCell, product: Product) {
        //
        print("Buying for the cart")
    }
    
    
    struct Constant {
        static let numberOfItemsCell = "numberOfItemsCell"      // cell 0
        static let itemCell = "itemCell"                        // cell 1
        static let cartDetailCell = "cartDetailCell"            // cell 2
        static let cartTotalCell = "cartTotalCell"              // cell 3
        static let checkoutButtonCell = "checkoutButtonCell"    // cell 4
        static let identifier = "identifier"
        
    }
    var products: [Product]? = Product.fetchShoes()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.tabBarBlue()
        self.tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(NumberOfItemsCell.self, forCellReuseIdentifier: Constant.numberOfItemsCell)
        tableView.register(ItemCell.self, forCellReuseIdentifier: Constant.itemCell)
        tableView.register(CartDetailCell.self, forCellReuseIdentifier: Constant.cartDetailCell)
        tableView.register(CartTotalCell.self, forCellReuseIdentifier: Constant.cartTotalCell)
        tableView.register(CheckoutButtonCell.self, forCellReuseIdentifier: Constant.checkoutButtonCell)
//        tableView.register(ItemCell.self, forCellReuseIdentifier: Constant.itemCell)
    }
  
}
extension ShoppingBagTableViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let products = products {
            return products.count + 4
        } else {
            return 1
        }
      

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let products = products else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.numberOfItemsCell, for: indexPath) as! NumberOfItemsCell
            cell.numberOfItemsLabel.text = "\(0) ITEM"
            
            return cell
        }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.numberOfItemsCell, for: indexPath) as! NumberOfItemsCell
            cell.numberOfItemsLabel.text = "\(products.count) ITEMS"
            return cell
        } else if indexPath.row == products.count + 1 {
            // cartDetailCell
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cartDetailCell, for: indexPath)
            
            return cell
        } else if indexPath.row == products.count + 2 {
            // cartTotalCell
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cartTotalCell, for: indexPath)
            
            return cell
        } else if indexPath.row == products.count + 3 {
            // checkoutButtonCell
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.checkoutButtonCell, for: indexPath) as! CheckoutButtonCell
            cell.delegate = self
            return cell
        } else {
            // itemCell
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.itemCell, for: indexPath) as! ItemCell
            cell.product = products[indexPath.row - 1]
            return cell
        }
    }
  
}



