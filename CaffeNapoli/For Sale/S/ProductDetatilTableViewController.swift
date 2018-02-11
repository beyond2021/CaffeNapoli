//
//  ProductDetatilTableViewController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/26/17.
//  Copyright © 2017 Kev1. All rights reserved.
//  STPAddCardViewControllerDelegate
import UIKit
import PassKit
import Stripe
import Contacts
class ProductDetatilTableViewController: UITableViewController, BuyButtonCellDelegate, CheckoutButtonCellDelegate{
    
    let settingsVC = SettingsViewController()
    func didBuyProduct(for cell: CheckoutButtonCell, product: Product) {
        //
        print("ready to buy from detailTV")
//        let product = Array(self.productsAndPrices.keys)[(indexPath as NSIndexPath).row]
        let product = product.name
        let price = 2000
        let checkoutViewController = CheckoutViewController(product: product!,
                                                            price: price,
                                                            settings: self.settingsVC.settings)
        self.navigationController?.pushViewController(checkoutViewController, animated: true)
        
        
    }
    
    var product: Product? {
        didSet {
            //            print("product is set in detail", product?.name)
        }
    }
    

   
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex, PKPaymentNetwork.discover]
    let ApplePaySwagMerchantID = "merchant.com.caffeNapoli" // Fill in your merchant ID here!
    
    func didBuyProduct(for cell: BuyButtonCell, product: Product) {
       print("ready to buy from Apple pay detailTV")
        /*
        if   PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: SupportedPaymentNetworks) && PKPaymentAuthorizationController.canMakePayments() {
            // Pay is available!
            print("ready for apple pay")
            let request = PKPaymentRequest()
            request.merchantIdentifier = ApplePaySwagMerchantID
            request.supportedNetworks = SupportedPaymentNetworks
            request.merchantCapabilities = PKMerchantCapability.capability3DS
            request.countryCode = "US"
            request.currencyCode = "USD"
            var summaryItems = [PKPaymentSummaryItem]()
            summaryItems.append(PKPaymentSummaryItem(label: product.name!, amount: product.price!))
            
            if (product.productType == .Delivered) {
                summaryItems.append(PKPaymentSummaryItem(label: "Shipping", amount: product.shippingPrice))
            }
            
            summaryItems.append(PKPaymentSummaryItem(label: "Caffe Napoli", amount: product.total()))
            request.paymentSummaryItems = summaryItems
            switch (product.productType) {
            case ProductType.Delivered:
                request.requiredShippingContactFields = [PKContactField.postalAddress,PKContactField.phoneNumber]
            case ProductType.Electronic:
                request.requiredShippingContactFields = [PKContactField.emailAddress]
            }
            
            
            guard let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request) else { return }
            applePayController.delegate = self
            present(applePayController, animated: true, completion: nil)
        } else {
            print("NOT ready for apple pay")
            let alert = UIAlertController(title: "This device is not ready for Apple Pay?", message: "Please use regular checkout.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
 */
 
    }
    
    var images : [UIImage]? {
        didSet {
//            let pageController = ProductImagesPageViewController()
//            pageController.images = images
        }
    }
    
    let pageControl : UIPageControl = {
        let pc = UIPageControl()
        //        pc.backgroundColor = .black
        pc.numberOfPages = 5
        pc.pageIndicatorTintColor = UIColor.rgb(displayP3Red: 185, green: 185, blue: 185)
        pc.currentPageIndicatorTintColor = UIColor.rgb(displayP3Red: 104, green: 104, blue: 104)
        return pc
    }()
    
    let pageController = ProductImagesPageViewController()
    let shoeDetailCell = "shoeDetailCell"
    let productDetailMoreCell = "productDetailMoreCell"
    let buyButtonCell = "buyButtonCell"
    let productDetailCell = "productDetailCell"
    let suggestionCell = "suggestionCell"
    let suggestionCollectionViewCell = "suggestionCollectionViewCell"
    let checkoutButtonCell = "checkoutButtonCell"
    
   
    //
    lazy var pageViewController : ProductImagesPageViewController = {
        let pvc = ProductImagesPageViewController()
        pvc.pageViewControllerDelegate = self
        pvc.images = images
        pvc.view.backgroundColor = .clear
        return pvc
    }()

    lazy var headerView: UIView = {
        let hv = UIView()
        hv.backgroundColor = UIColor.tabBarBlue()
        hv.frame = CGRect(x: 0, y: 0, width: 375, height: 507)
        return hv
    }()
    
    //
//    lazy var floationgShoppingCartButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.addTarget(self, action: #selector(viewCart), for: .touchUpInside)
//        button.setImage(#imageLiteral(resourceName: "shoppingBageFilled").withRenderingMode(.alwaysOriginal), for: .normal)
//        button.layer.cornerRadius = 100/2
//        button.backgroundColor = .clear
//        button.clipsToBounds = true
//        return button
//    }()
//
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
        headerView.addSubview(pageViewController.view)
        pageViewController.view.anchor(top: headerView.topAnchor, left: headerView.leftAnchor, bottom: nil, right: headerView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 350)
        headerView.addSubview(pageControl)
        pageControl.anchor(top: pageViewController.view.bottomAnchor, left: nil, bottom:headerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 37)
        pageControl.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        tableView.register(ShoeDetailCell.self, forCellReuseIdentifier:shoeDetailCell)
        tableView.register(BuyButtonCell.self, forCellReuseIdentifier: buyButtonCell)
        tableView.register(ProductDetailCell.self, forCellReuseIdentifier: productDetailCell)
        tableView.register(SuggestionCell.self, forCellReuseIdentifier: suggestionCell)
        tableView.register(ProductDetailMoreCell.self, forCellReuseIdentifier: productDetailMoreCell)
        tableView.register(CheckoutButtonCell.self, forCellReuseIdentifier: checkoutButtonCell)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "scartGrFull"), style: .plain, target: self, action: #selector(viewCart))

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return self.tableView.bounds.width + 68
        } else {
            return UITableViewAutomaticDimension
        }
    }
}

extension ProductDetatilTableViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 0 - shoe detail cell
        // 1 - buy button
        // 2 - shoe full details button cell
        // 3 - you might like this cell
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: productDetailCell, for: indexPath) as! ProductDetailCell
            cell.product = product
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: buyButtonCell, for: indexPath) as! BuyButtonCell
            cell.delegate = self
            cell.product = product
            cell.buyButton.isHidden = !PKPaymentAuthorizationController.canMakePayments(usingNetworks: SupportedPaymentNetworks)
            return cell
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: checkoutButtonCell, for: indexPath) as! CheckoutButtonCell
            cell.delegate = self
            cell.product = product
            return cell
        }  else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: productDetailMoreCell, for: indexPath) as! ProductDetailMoreCell
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
        if indexPath.row == 4 {
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let products = Product.fetchShoes()
        guard let thisItem = products[indexPath.item].name  else {return}
        print("You have selected \(thisItem)")
        let alert = UIAlertController(title: thisItem, message: "Would You Like to purchace this item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue shopping", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil) 
        
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

extension ProductDetatilTableViewController : ProductImagesPageViewControllerDelegate
{
    
    func setupPageController(numberOfPages: Int)
    {
        pageControl.numberOfPages = numberOfPages
    }
    
    func turnPageController(to index: Int)
    {
        pageControl.currentPage = index
    }
}
extension ProductDetatilTableViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        //
    }
    
   
//
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//         controller.dismiss(animated: true, completion: nil)
//    }
//
//
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {
////        completion(PKPaymentAuthorizationStatus.success)
//        // 1
//        //        let shippingAddress = createShippingAddressFromRef(address: (payment.shippingContact as? PKContact)!)
//        Stripe.setDefaultPublishableKey("sk_live_re1sxO5hvmLEGVvsQtTuaQk1")  // Replace With Your Own Key!
//        // 3
//        STPAPIClient.shared().createToken(with: payment) {
//            (token, error) -> Void in
//
//            if (error != nil) {
//                print(error as Any)
//                completion(PKPaymentAuthorizationStatus.failure)
//                return
//            }
//            // 4
//            let shippingAddress = self.createShippingAddressFromRef(address: (payment.shippingContact )!)
//            // 5
//            let url = NSURL(string: "http://192.168.1.3:5000/pay")  // Replace with computers local IP Address!
//            let request = NSMutableURLRequest(url: url! as URL)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//            // 6
//            let body = ["stripeToken": token?.tokenId ?? "",
//                        "amount": self.product!.total().multiplying(by: NSDecimalNumber(string: "100")),
//                        "description": self.product!.name as Any,
//                        "shipping": [
//                            "city": shippingAddress.City!,
//                            "state": shippingAddress.State!,
//                            "firstName": shippingAddress.FirstName!,
//                            "lastName": shippingAddress.LastName!]
//                ] as [String : Any]
//
//            // 7
//            do {
//
//                try request.httpBody = JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
//                let session = URLSession.shared
//                let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
//                    // do stuff with response, data & error here
//                    if let error = error {
//                        completion(PKPaymentAuthorizationStatus.failure)
//                        print("Payment failure:", error)
//                        return
//                    }
//
//                    completion(PKPaymentAuthorizationStatus.success)
//                    print("Payment success")
//
//                })
//                task.resume()
//            } catch  {
//                print("address failed ...",error)
//            }
//        }
    
//    }
    
    //MARK:- Shipping Address
    
//    func createShippingAddressFromRef(address: PKContact) -> Address {
//        var shippingAddress: Address = Address()
//        let contact = address.name
//        shippingAddress.FirstName = contact?.givenName
//        shippingAddress.LastName = contact?.familyName
//        let contactAddress = address.postalAddress
//        shippingAddress.Street = contactAddress?.street
//        shippingAddress.City = contactAddress?.city
//        shippingAddress.State = contactAddress?.state
//        return shippingAddress
//
//    }
//
//    //Shipping Method
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, handler completion: @escaping (PKPaymentRequestShippingMethodUpdate) -> Void) {
//        //
//    }
//
    
    
}



