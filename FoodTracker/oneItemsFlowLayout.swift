//
//  oneItemsFlowLayout.swift
//  FoodTracker
//
//  Created by 一戸悠河 on 2017/02/28.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit

class oneItemsFlowLayout: UICollectionViewFlowLayout {
    override var itemSize: CGSize {
        set {
            var height = UIScreen.main.bounds.size.width
            self.itemSize = CGSize(width: height, height: height)
        }
        get {
            var height = UIScreen.main.bounds.size.width
            return CGSize(width: height, height: height)
        }
    }
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .horizontal
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.frame.width)-1
    }
    
    func itemHeight() -> CGFloat {
        return itemWidth()*2
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}
