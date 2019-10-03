//
//  TrendingCell.swift
//  youtube
//
//  Created by adam on 02/10/2019.
//  Copyright © 2019 adam. All rights reserved.
//

import UIKit

class HomeCell: FeedCell {
    override func fetchVideos() {
        ApiService.sharedInstance.fetchVideos(url: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json") { (videos: [Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
