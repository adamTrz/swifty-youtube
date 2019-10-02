//
//  ViewController.swift
//  youtube
//
//  Created by adam on 28/09/2019.
//  Copyright © 2019 adam. All rights reserved.
//

import UIKit

class YoutubeController: UICollectionViewController {

    fileprivate let cellId = "cellId"
    
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchVideos()
        setupNavigationBar()
        setupMenuBar()
    }

    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: menuBarHeight, left: 0, bottom: 0, right: 0)
    }

    fileprivate func fetchVideos() {
        ApiService.sharedInstance.fetchVideos { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
    let menuBar: MenuBar = {
        let menu = MenuBar()
        return menu
    }()
    
    private func setupMenuBar(){
        
        let navBarUnderlay = UIView()
        navBarUnderlay.backgroundColor = .systemBackground
        view.addSubview(navBarUnderlay)
        view.addConstraintsWithFormat("H:|[v0]|", views: navBarUnderlay)
        view.addConstraintsWithFormat("V:[v0(50)]", views: navBarUnderlay)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:[v0(\(menuBarHeight))]", views: menuBar)
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    fileprivate func setupNavigationBar() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.isTranslucent = false
        let searchBarButtonItem = makeBarButton(imageName: "search", selector: #selector(handleSearch), size: 24)
        let moreBarButtonItem = makeBarButton(imageName: "more_vert", selector: #selector(handleMore), size: 24)
        navigationItem.rightBarButtonItems = [
            moreBarButtonItem, searchBarButtonItem
        ]
    }
    
    fileprivate func makeBarButton(imageName: String, selector: Selector, size: CGFloat) -> UIBarButtonItem {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: .custom)
        button.tintColor = .label
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        let currWidth = barButtonItem.customView?.widthAnchor.constraint(equalToConstant: size)
        currWidth?.isActive = true
        let currHeight = barButtonItem.customView?.heightAnchor.constraint(equalToConstant: size)
        currHeight?.isActive = true
        return barButtonItem
    }
    
    @objc func handleSearch() {
        print("searchBarButtonItem")
    }
    
    // Need to lazily create an instance of SettingsOverlay and pass self as a homeController
    // This way, SettingsOverlay would have access to it and can call from itself
    // `self.homeController?.showControllerForSetting()`
    lazy var settingsOverlay: SettingsOverlay = {
        let launcher = SettingsOverlay()
        launcher.homeController = self
        return launcher
    }()
    
    @objc func handleMore() {
        settingsOverlay.showOverlay()
    }
    
    func showControllerForSetting(_ setting: Setting) {
        let dummyVC = UIViewController()
        dummyVC.navigationItem.title = setting.name.rawValue
        dummyVC.view.backgroundColor = .systemBackground
        navigationController?.pushViewController(dummyVC, animated: true)
    }
}


extension YoutubeController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoCell
        cell.video = videos[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = (width - 16 - 16) * 9 / 16
        return CGSize(width: width, height: height + 16 + 8 + 64 + 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
