//
//  User.swift
//  GithubClient
//
//  Created by Gru on 04/21/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

import UIKit

struct User {
    let name        : String
    let avatarURL   : String
    let htmlURL     : String
    var avatarImage : UIImage?

    init( userJSONDictionary: [String : AnyObject] ) {
        self.name        = userJSONDictionary["login"] as String
        self.avatarURL   = userJSONDictionary["avatar_url"] as String
        self.htmlURL     = userJSONDictionary["html_url"] as String
        self.avatarImage = userJSONDictionary["avatar_image"] as UIImage?
    }
}