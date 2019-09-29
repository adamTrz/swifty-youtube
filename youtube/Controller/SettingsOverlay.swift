//
//  SettingsOverlay.swift
//  youtube
//
//  Created by adam on 29/09/2019.
//  Copyright © 2019 adam. All rights reserved.
//

import UIKit

class SettingsOverlay: NSObject {
        
    fileprivate let cellId = "settingsCell"
    fileprivate let cellHeight: CGFloat = 50
    let overlayView = UIView()
    
    let collectionView: UICollectionView = { 
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.systemBackground
        cv.isScrollEnabled = false
        return cv
    }()
    
    let settings: [Setting] = {
        let setting = Setting(name: .Settings, icon: "settings")
        let account = Setting(name: .Account, icon: "account")
        let feedback = Setting(name: .Feedback, icon: "feedback")
        let help = Setting(name: .Help, icon: "help")
        let cancel = Setting(name: .Cancel, icon: "close")
        let terms = Setting(name: .Terms, icon: "lock")

        return [setting, terms, feedback, help, account, cancel]
    }()
    
    var homeController: YoutubeController?

    func showOverlay() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            overlayView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
            window.addSubview(overlayView)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settings.count) * cellHeight
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
    
    @objc func handleTap() {
        handleDismiss()
    }
    
    func handleDismiss(forSetting setting: Setting? = nil) {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            UIView.animate(withDuration: 0.3, animations: {
                self.overlayView.alpha = 0
                self.collectionView.frame.origin.y = window.frame.height
            }) { (_) in
                self.collectionView.removeFromSuperview()
                self.overlayView.removeFromSuperview()
                if let setting = setting, setting.name != .Cancel {
                    self.homeController?.showControllerForSetting(setting)
                }
            }
        }
    }
        
    override init() {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
    }
    
}

extension SettingsOverlay: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        cell.item = settings[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = settings[indexPath.item]
        handleDismiss(forSetting: setting)
    }
    
}
