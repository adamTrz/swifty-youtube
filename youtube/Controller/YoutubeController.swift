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
    
    var videos: [Video] = {
        var channel = Channel(name: "TaylorSwiftVEVO", profileImageName: "taylor_swift_profle")

        var blankSpaceVideo = Video(thumbnail: "taylor_swift_blank_space", title: "Taylor Swift - Blank Space", channel: channel, numberOfViews: 2499721878, upladDate: Date())
        //10 lis 2014"
        var badBloodVideo = Video(thumbnail: "bad_blood", title: "Taylor Swift - Bad Blood featuring Kendrick Lamar", channel: channel, numberOfViews: 1316399408, upladDate: Date())
        // 17 maj 2015
        return [blankSpaceVideo, badBloodVideo]
    }()
    
    override func viewDidLoad() {
        setNeedsStatusBarAppearanceUpdate()
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.contentInset = UIEdgeInsets(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: menuBarHeight, left: 0, bottom: 0, right: 0)
        setupNavigationBar()
        setupMenuBar()
    }
    
    let menuBar: MenuBar = {
        let menu = MenuBar()
        return menu
    }()
    
    private func setupMenuBar(){
        view.addSubview(menuBar)
        view.addConstraintsWithFormat("H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat("V:|[v0(\(menuBarHeight))]|", views: menuBar)
    }
    
    fileprivate func setupNavigationBar() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.isTranslucent = false
        // TODO: Investigate WTF?
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = barColor
        navigationController?.navigationBar.isTranslucent = false
        let searchBarButtonItem = makeBarButton(imageName: "search", selector: #selector(handleSearch), size: 24)
        let moreBarButtonItem = makeBarButton(imageName: "more_vert", selector: #selector(handleSearch), size: 24)
        navigationItem.rightBarButtonItems = [
            searchBarButtonItem, moreBarButtonItem
        ]
    }
    
    fileprivate func makeBarButton(imageName: String, selector: Selector, size: CGFloat) -> UIBarButtonItem {
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: .custom)
        button.tintColor = .white
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
    
    // TODO: Investigate WTF?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
