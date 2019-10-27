//
//  TwirlCollectionViewBase.swift
//  Twirl
//
//  Created by Aedan Joyce on 6/15/18.
//  Copyright © 2018 Aedan Joyce. All rights reserved.
//

import UIKit
class TwirlCollectionViewBase: UICollectionViewCell, UICollectionViewDelegateFlowLayout {
    var homeViewDelegate: HomeViewDelegate?
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        layout.scrollDirection = .vertical
        cv.delegate = self
        return cv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        addContraintsWithFormat("H:|[v0]|", views: collectionView)
        addContraintsWithFormat("V:|[v0]|", views: collectionView)
        collectionView.layer.cornerRadius = 20
        //collectionView.delaysContentTouches = false
        if #available(iOS 11.0, *) {
            collectionView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addContraintsWithFormat(_ format: String, views: UIView...) {
        var viewDict = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDict[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
    }
}
