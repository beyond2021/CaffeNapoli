//
//  ProductImagesHeaderView.swift
//  CaffeNapoli
//
//  Created by Kev1 on 12/27/17.
//  Copyright © 2017 Kev1. All rights reserved.
//

import UIKit
class ProductImagesHeaderView : UIView {
    var images : [UIImage]?
    
    lazy var pageViewController : ProductImagesPageViewController = {
        let pvc = ProductImagesPageViewController()
        pvc.pageViewControllerDelegate = self
//        pvc.images = images
        pvc.view.backgroundColor = .clear
        return pvc

    }()

  
//    
    let pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.backgroundColor = .clear
//        pc.numberOfPages = 5
        pc.pageIndicatorTintColor = UIColor.rgb(displayP3Red: 185, green: 185, blue: 185)
        pc.currentPageIndicatorTintColor = UIColor.rgb(displayP3Red: 104, green: 104, blue: 104)
        return pc
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pageViewController.view)
        pageViewController.view.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 533)
        pageViewController.view.addSubview(pageControl)
        pageControl.anchor(top: nil, left: nil, bottom:pageViewController.view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 39, height: 37)
        pageControl.centerXAnchor.constraint(equalTo:pageViewController.view.centerXAnchor).isActive = true
//        let prodImagesViewController = ProductImagesPageViewController()
//        prodImagesViewController.pageViewControllerDelegate = self
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ProductImagesHeaderView : ProductImagesPageViewControllerDelegate
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


