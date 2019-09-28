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
            if let thumbnail = video?.thumbnailImageName {
                thumbnailImageView.image = UIImage(named: thumbnail)
            }
            if let profileImage = video?.channel?.profileImageName {
                profileImageView.image = UIImage(named: profileImage)
            }
            let numberFormatter = NumberFormatter()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            numberFormatter.numberStyle = .decimal
            if let numberOfViews = video?.numberOfViews,
                let date = video?.upladDate,
                let channelName = video?.channel?.name {
                subtitleTextView.text = "\(channelName) • \(dateFormatter.string(from: date)) • \(numberFormatter.string(from: numberOfViews)!) views"
            }
            // Measure titleLabel text
            if let title = video?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 16)], context: nil)
                print(estimatedRect.size.height)
                if estimatedRect.size.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }
            }
        }
    }
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
    }()
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .secondaryLabel

        return label
    }()
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = ""
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = .systemGray
        return textView
    }()

    var titleLabelHeightConstraint: NSLayoutConstraint?
    
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
        
        addConstraintsWithFormat("V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView, profileImageView, separator)
        
        // titleLabel
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: profileImageView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
         titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)
        addConstraint(titleLabelHeightConstraint!)
        // subtitleTextView
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: profileImageView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
    }
}
