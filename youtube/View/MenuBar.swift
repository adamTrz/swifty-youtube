//
//  ManuBar.swift
//  youtube
//
//  Created by adam on 28/09/2019.
//  Copyright © 2019 adam. All rights reserved.
//

import UIKit

fileprivate let cellId = "menuCell"

class MenuBar: UIView {
        
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .bottom)
        setupBarIndicator()
    }
    
    var barIndicatorLeftAnchorConstraint: NSLayoutConstraint?
    var homeController: YoutubeController?
    
    func setupBarIndicator() {
        let indicator = UIView()
        indicator.backgroundColor = themeRed
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        barIndicatorLeftAnchorConstraint = indicator.leftAnchor.constraint(equalTo: self.leftAnchor)
        barIndicatorLeftAnchorConstraint?.isActive = true
        indicator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        indicator.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuBar: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: tabs[indexPath.row].icon)?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = .label
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        homeController?.scrollToItemAtIndex(index: indexPath.item)
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
}


