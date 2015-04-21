//
//  Repository.swift
//  GithubClient
//
//  Created by Gru on 04/10/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

import Foundation

struct Repository {

    let name:       String
    let author:     String!             //  owner
    let     avatarURL:  String!         //  avatar_url
    let     gravatarId:  String!        //  gravatar_id
    let     id:  Int!                   //  id
    let     login:  String!             //  login
    let     receivedEventsURL:  String! //  received_events_url
    let     type:  String!              //  type
    let     url:  String!               //  url
    let htmlURL: String                 // html_url
    let createdAt: String               // created_at


    init( jsonRepository : [String : AnyObject]) {
        self.name       = jsonRepository["name"]      as String
        self.htmlURL    = jsonRepository["html_url"]  as String
        self.createdAt  = jsonRepository["created_at"] as String

        if let owner = jsonRepository["owner"] as? [String : AnyObject] {
            self.author             = owner["login"] as String
            self.avatarURL          = owner["avatar_url"] as String
            self.gravatarId         = owner["gravatar_id"] as String
            self.id                 = owner["id"] as Int
            self.login              = owner["login"] as String
            self.receivedEventsURL  = owner["received_events_url"] as String
            self.type               = owner["type"] as String
            self.url                = owner["url"] as String
        }
    }

    func printRepositoryEntry( index : Int ) {

    }
}
