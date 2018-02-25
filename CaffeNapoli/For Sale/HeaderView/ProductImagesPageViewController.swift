//
//  ProductImagesPageViewController.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/27/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit

protocol ProductImagesPageViewControllerDelegate: class
    
{
    func setupPageController(numberOfPages: Int)
    func turnPageController(to index: Int)
}



class ProductImagesPageViewController: UIPageViewController {
    
    struct Constant {
        static let productsImageViewController = "ProductsImageViewController"
    }
    //
    //    var aNum  : Int? {
    //        didSet {
    //            guard let n = aNum else { return }
    //
    //            print("Anum is now set ...",n)
    //            images?.removeAll()
    //            images = Product.fetchShoes()[aNum!].images
    //            print(images?.count)
    //        }
    //    }
    var images: [UIImage]?
    weak var pageViewControllerDelegate: ProductImagesPageViewControllerDelegate?
    lazy var controllers: [UIViewController] = {
        let productImagesViewController = ProductImagesViewController()
        var controllers = [UIViewController]()
        if let images = self.images {
            for image in images {
                let productImagesViewController = ProductImagesViewController()
                controllers.append(productImagesViewController)
            }
        }
        self.pageViewControllerDelegate?.setupPageController(numberOfPages: controllers.count)
        return controllers
    }()
    
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor.tabBarBlue()
        dataSource = self
        delegate = self
        self.turnToPage(index: 0)
    }
    
    func turnToPage(index: Int)
    {
        let controller = controllers[index]
        var direction = UIPageViewControllerNavigationDirection.forward
        if let currentVC = viewControllers?.first {
            let currentIndex = controllers.index(of: currentVC)!
            if currentIndex > index {
                direction = .reverse
            }
        }
        self.configureDisplaying(viewController: controller)
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
    func configureDisplaying(viewController: UIViewController)
    {
        for (index, vc) in controllers.enumerated() {
            if viewController === vc {
                if let shoeImageVC = viewController as? ProductImagesViewController {
                    shoeImageVC.image = self.images?[index]
                    
                    self.pageViewControllerDelegate?.turnPageController(to: index)
                }
            }
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension ProductImagesPageViewController : UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        if let index = controllers.index(of: viewController) {
            if index > 0 {
                return controllers[index-1]
            }
        }
        return controllers.last
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        if let index = controllers.index(of: viewController) {
            if index < controllers.count - 1 {
                return controllers[index + 1]
            }
        }
        return controllers.first
    }
}

extension ProductImagesPageViewController : UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
        self.configureDisplaying(viewController: pendingViewControllers.first as! ProductImagesViewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if !completed {
            self.configureDisplaying(viewController: previousViewControllers.first as! ProductImagesViewController)
        }
    }
}




