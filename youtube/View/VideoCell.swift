//
//  VideoCell.swift
//  youtube
//
//  Created by adam on 28/09/2019.
//  Copyright © 2019 adam. All rights reserved.
//

import UIKit

class VideoCell: BaseCell {
    
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            if let thumbnail = video?.thumbnailImageUrl {
                thumbnailImageView.loadFromUrlString(thumbnail)
            }
            if let profileImage = video?.channel?.profileImageUrl {
                profileImageView.loadFromUrlString(profileImage)
            }
            let numberFormatter = NumberFormatter()
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateStyle = .medium
            numberFormatter.numberStyle = .decimal
            if let numberOfViews = video?.numberOfViews,
//                let date = video?.upladDate,
                let channelName = video?.channel?.name {
                subtitleTextView.text = "\(channelName) • 2 months ago • \(numberFormatter.string(from: numberOfViews)!) views"
            }
        }
    }
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    let thumbnailImageView: NetworkImageView = {
        let imageView = NetworkImageView()
        imageView.image = UIImage(named: "bad_blood")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    let profileImageView: NetworkImageView = {
        let imageView = NetworkImageView()
        imageView.image = UIImage(named: "taylor_swift_profle")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = ""
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = .lightGray
        return textView
    }()

    override func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(separator)
        addSubview(profileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)

        // MARK: - Constraints
        addConstraintsWithFormat("H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithFormat("H:|[v0]|", views: separator)
        addConstraintsWithFormat("H:|-16-[v0(44)]", views: profileImageView)
        
        addConstraintsWithFormat("V:|-16-[v0]-8-[v1(44)]-32-[v2(1)]|", views: thumbnailImageView, profileImageView, separator)
        
        // titleLabel
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: profileImageView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        
        // subtitleTextView
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: profileImageView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
    }
}
