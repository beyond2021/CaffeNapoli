//
//  ProductDetatilTableViewController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/26/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
class ProductDetatilTableViewController: UITableViewController, BuyButtonCellDelegate {
    func didBuyProduct(for cell: BuyButtonCell) {
//         print("Buying product", cell)
    }
    
    
    
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
    
    //
    lazy var floationgShoppingCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(viewCart), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "shoppingBagEmpty").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.cornerRadius = 100/2
        button.backgroundColor = .clear
        button.clipsToBounds = true
        return button
    }()
    
    @objc fileprivate func viewCart() {
        print("Trying to view cart...")
        let shoppingBagTableViewController = ShoppingBagTableViewController()
        self.navigationController?.pushViewController(shoppingBagTableViewController, animated: true)
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = product?.name
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableHeaderView = headerView
        tableView.register(ShoeDetailCell.self, forCellReuseIdentifier:shoeDetailCell)
        tableView.register(BuyButtonCell.self, forCellReuseIdentifier: buyButtonCell)
        tableView.register(ProductDetailCell.self, forCellReuseIdentifier: productDetailCell)
        tableView.register(SuggestionCell.self, forCellReuseIdentifier: suggestionCell)
        self.navigationController?.view.addSubview(floationgShoppingCartButton)
        floationgShoppingCartButton.anchor(top: nil, left: nil, bottom: self.navigationController?.view.bottomAnchor, right: self.navigationController?.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 20, width: 100, height: 100)

        let cv = CartCurvedView(frame: view.frame)
        cv.backgroundColor = .yellow
//        UIApplication.shared.keyWindow?.addSubview(cv)
        
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
            cell.delegate = self
            

            
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


func shoppingBagCustomPath() -> UIBezierPath {
//        let indexPath = IndexPath(row: 1, section: 0)
//        let rectOfCell = tableView.rectForRow(at: indexPath)
//        let rectOfCellInSuperview = tableView.convert(rectOfCell, to: tableView.superview)
//        print(rectOfCellInSuperview)
//
    let bounds = UIScreen.main.bounds
    let width = bounds.size.width
    let height = bounds.size.height
    
    
        let path = UIBezierPath()
        //starting point
        path.move(to: CGPoint(x: 20, y: 480))
//        let cellRect = rectOfCellInSuperview
        let startingPoint = CGPoint(x:width / 2, y: height / 2)
        path.move(to: startingPoint)
        //
        let shoppingBag = CGPoint(x:height - 70, y: width - 70)
        
        let endPoint = shoppingBag
        //        path.addLine(to: endPoint)
       let xDistance = (width - 70) - (width / 2)
        let arcTop = CGPoint(x: xDistance, y: 100)
        let cp1 = arcTop
        let cp2 = endPoint
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        return path
        
    }

class CartCurvedView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        // we will do some fancy drawing
     
//        let path = shoppingBagCustomPath()
//        path.lineWidth = 3
//        path.stroke()
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: width / 2, y: height / 2 + 290))
        let endPoint = CGPoint(x: width - 70, y: height + 470)
        let cp1 = CGPoint(x: (width / 3) * 2, y: -100)
        let cp2 = CGPoint(x: width - 70, y: height / 2 + 290)
        
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
//        path.addLine(to: endPoint)
        UIColor.lightGray.setStroke()
        path.lineWidth = 5
        path.stroke()
        
    }
}
