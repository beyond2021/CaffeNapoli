//
//  ShoppingCartController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/14/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

class ShoppingCartController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    var products: [Product]?
    let cellId = "cellId"
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(dismissCart), for: .touchUpInside)
        
        return button
    }()
    
    let cartLabel: UILabel = {
        let label = UILabel()
        label.text = "Shopping Cart Goes Here"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    @objc func dismissCart() {
        print("Dismissing cart....")
        dismiss(animated: true, completion: nil)
        
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItems()
//        collectionView?.backgroundColor = .white
        collectionView?.backgroundColor = UIColor.tabBarBlue()
        collectionView?.register(ShoppingCartCell.self, forCellWithReuseIdentifier: cellId)
        navigationItem.title = "FOR SALE"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.tabBarBlue()]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        products = Product.fetchShoes()
//        print("Proucts are:", products)
        
        collectionView?.reloadData()
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.tabBarBlue()
//        self.tableView.estimatedRowHeight = tableView.rowHeight
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//
        collectionView?.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 24, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
        
        
    }
    
    fileprivate func setUpNavigationItems() {
//        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "CaffeNapLogoSmallBlack"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "dismissGreen").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(dismissCart))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.tabBarBlue()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "shopping-cart-50").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCart))
    }
    
    
    
    //MARK:- Datasource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let products = products {
            return products.count
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ShoppingCartCell
        
        
        cell.product = self.products?[indexPath.row]
        
        print(cell.product)
        
        return cell
    }
    //MARK:- Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.width + 24 + 31 + 8 + 10
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //    print("preseeing ...", indexPath.item)
        guard let myProduct = products?[indexPath.item] else { return }
        //    print("products are :", myProduct.images?.count)
        let detailViewController = ProductDetatilTableViewController()
        detailViewController.images = myProduct.images
        detailViewController.product = myProduct
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    
}
