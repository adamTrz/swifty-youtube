//
//  ApiService.swift
//  youtube
//
//  Created by adam on 29/09/2019.
//  Copyright © 2019 adam. All rights reserved.
//

import UIKit

class ApiService: NSObject {

    static let sharedInstance = ApiService()
    
    var dataTask: URLSessionDataTask?

    func fetchVideos(completion: @escaping([Video]) -> ()) {
        dataTask?.cancel()
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        let session = URLSession(configuration: .default)
        dataTask = session.dataTask(with: url!) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            if error != nil {
                print(error!)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                var videos = [Video]()
                for item in json as! [[String: AnyObject]] {
                    let video = Video(
                        thumbnail: item["thumbnail_image_name"] as? String,
                        title: item["title"] as? String,
                        channel: Channel(
                            name: item["channel"]?["name"] as? String,
                            profileImageName: item["channel"]?["profile_image_name"] as? String
                        ),
                        numberOfViews: item["number_of_views"] as? NSNumber
                    )
                    videos.append(video)
                }
                DispatchQueue.main.async {
//                    self?.collectionView.reloadData()
                    completion(videos)
                }
            } catch {
                print(error)
            }
        }
        dataTask!.resume()

    }
    
}
