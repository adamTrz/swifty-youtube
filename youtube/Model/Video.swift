//
//  Video.swift
//  youtube
//
//  Created by adam on 28/09/2019.
//  Copyright © 2019 adam. All rights reserved.
//

import UIKit

struct Video {
    var thumbnailImageUrl: String?
    var title: String?
    var numberOfViews: NSNumber?
    var channel: Channel?
    
    init(thumbnail: String?, title: String?, channel: Channel?, numberOfViews: NSNumber?) {
        self.thumbnailImageUrl = thumbnail
        self.title = title
        self.channel = channel
        self.numberOfViews = numberOfViews
    }
}

struct Channel {
    var name: String?
    var profileImageUrl: String?
    
    init(name: String?, profileImageName: String?) {
        self.name = name
        self.profileImageUrl = profileImageName
    }
    
}
