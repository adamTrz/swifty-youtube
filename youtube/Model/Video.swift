//
//  Video.swift
//  youtube
//
//  Created by adam on 28/09/2019.
//  Copyright © 2019 adam. All rights reserved.
//

import UIKit

struct Video {
    var thumbnailImageName: String?
//    var profileImageName: String?
    var title: String?
    var upladDate: Date?
    var numberOfViews: NSNumber?
    var channel: Channel?
    
    init(thumbnail: String, title: String, channel: Channel, numberOfViews: NSNumber?, upladDate: Date?) {
        self.thumbnailImageName = thumbnail
        self.title = title
        self.channel = channel
        self.numberOfViews = numberOfViews
        self.upladDate = upladDate
    }
}

struct Channel {
    var name: String?
    var profileImageName: String?
    
    init(name: String, profileImageName: String) {
        self.name = name
        self.profileImageName = profileImageName
    }
    
}
