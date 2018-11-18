//
//  HeaderStrechyLayout.swift
//  CaffeNapoli
//
//  Created by KEEVIN MITCHELL on 11/7/18.
//  Copyright © 2018 Kev1. All rights reserved.
//

import UIKit
class HeaderStrechyLayout : UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        let offSet = collectionView!.contentOffset
        if (offSet.y < 0) {
            let deltaY = abs(offSet.y)
            for attributes in layoutAttributes! {
                if let elementKind = attributes.representedElementKind {
                    if  elementKind == UICollectionView.elementKindSectionHeader {
                        var frame = attributes.frame
                        frame.size.height = max(0, headerReferenceSize.height + deltaY)
                        frame.origin.y = frame.minY - deltaY
                        attributes.frame = frame
                    }
                    
                }
                
            }
            
        }
        return layoutAttributes
    }
    //header will be relaid out with each scroll
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
        
    }
}
