//
//  SettingsCell.swift
//  youtube
//
//  Created by adam on 29/09/2019.
//  Copyright © 2019 adam. All rights reserved.
//


import UIKit

class SettingsCell: BaseCell {
    
    var item: Setting? {
        didSet {
            labelView.text = item?.name.rawValue
            if let icon = item?.icon {
                iconView.image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
                iconView.tintColor = .label
            }
        }
    }
    
    let labelView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(labelView)
        addSubview(iconView)
        addConstraintsWithFormat("V:[v0(24)]", views: iconView)
        addConstraintsWithFormat("H:|-16-[v0(24)]-8-[v1]|", views: iconView, labelView)
        addConstraintsWithFormat("V:|[v0]|", views: labelView)
        addConstraint(NSLayoutConstraint(item: iconView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .systemGray6 : .systemBackground
        }
    }
}
