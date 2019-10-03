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
    fileprivate let trendingCellId = "trendingCellId"
    fileprivate let subscriptionsCellId = "subscriptionsCellId"
    fileprivate let homeCellId = "homeCellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        setupMenuBar()
    }

    fileprivate func setupCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        collectionView.contentInset = UIEdgeInsets(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemBackground
        collectionView.isPagingEnabled = true
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView.register(SubscriptionsCell.self, forCellWithReuseIdentifier: subscriptionsCellId)
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: homeCellId)
    }
    
    lazy var menuBar: MenuBar = {
        let menu = MenuBar()
        // Assign self as a MenuBars homeController so it can call our internal methods e.g. scrollToItemAtIndex(index)
        menu.homeController = self
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
    
    func scrollToItemAtIndex(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        setTitleForIndex(index)
    }

    fileprivate func setTitleForIndex(_ index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(tabs[index].name)"
        }
    }

    fileprivate func setupNavigationBar() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
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
        return tabs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String
        if indexPath.item == 1 {
            identifier = trendingCellId
        } else if indexPath.item == 2 {
            identifier = subscriptionsCellId
        } else if indexPath.item == 3 {
            identifier = homeCellId
        } else {
            identifier = cellId
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: view.frame.width, height: view.frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.barIndicatorLeftAnchorConstraint?.constant = scrollView.contentOffset.x / CGFloat(tabs.count)
    }
    
    // On end of the scroll get index of target screen and then select apropriate index to MenuBar to select its cell. Also, change navigation bar title
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        setTitleForIndex(index)

    }
    
}
