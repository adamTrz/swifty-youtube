//
//  SettingsOverlay.swift
//  youtube
//
//  Created by adam on 29/09/2019.
//  Copyright © 2019 adam. All rights reserved.
//

import UIKit

class SettingsOverlay: NSObject {
    
    let overlayView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.systemBackground
        return cv
    }()
    
    func showOverlay() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            overlayView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(overlayView)
            window.addSubview(collectionView)
            
            let height: CGFloat = 200
            let frame = window.frame
            let windowHeight = frame.height
            let windowWidth = frame.width
            let y = windowHeight - height
            collectionView.frame = CGRect(x: 0, y: windowHeight, width: windowWidth, height: height)
            overlayView.frame = frame
            overlayView.alpha = 0
            UIView.animate(withDuration: 0.4) {
                self.overlayView.alpha = 1
                self.collectionView.frame.origin.y = y
            }
        }
    }
    
    @objc func handleDismiss() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            UIView.animate(withDuration: 0.3, animations: {
                self.overlayView.alpha = 0
                self.collectionView.frame.origin.y = window.frame.height
            }) { (_) in
                self.collectionView.removeFromSuperview()
                self.overlayView.removeFromSuperview()
            }
        }
    }
    
    override init() {
        super.init()
    }
    
}
