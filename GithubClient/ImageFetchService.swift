//
//  ImageFetchService.swift
//  GithubClient
//
//  Created by Gru on 04/22/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

import UIKit


class ImageFetchService {

    let imageQueue = NSOperationQueue()

    func fetchImageForURL(url : String, imageViewSize : CGSize, completionHandler : (UIImage?) -> (Void)) {
        self.imageQueue.addOperationWithBlock { () -> Void in
            if let imageData = NSData(contentsOfURL: NSURL(string: url)!) {
                let image = UIImage(data: imageData)
                let resizedImageThumbnail = ImageResizer.resizeImage(image!, size: imageViewSize)

                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completionHandler(resizedImageThumbnail)
                })
            }
        }
    }
}