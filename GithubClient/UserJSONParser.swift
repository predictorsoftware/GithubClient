//
//  UserJSONParser.swift
//  GithubClient
//
//  Created by Gru on 04/22/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

import Foundation

class UserJSONParser {

    class func usersFromJSONData( data : NSData) -> [User] {

        var users = [User]()
        var jsonError : NSError?

        let jsonDictionary = NSJSONSerialization.JSONObjectWithData( data, options: nil, error: &jsonError) as? [String : AnyObject]

        if jsonError == nil {
            println( "usersFromJSONData[\(jsonDictionary?.count)]" )
            println( "usersFromJSONData[\(jsonDictionary?.keys)]" )

//            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as? [String: AnyObject] {
//                if let items = jsonDictionary["items"] as? [[String:AnyObject]] {
//                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                        trailingClosure(TrendEngineForTicker(tickerSymbol: tickerSymbol,firstJSONBlob: arrayOfResults),nil)
//                    })
//                }
//            }

//            let items = jsonDictionary["items"] as? [String : AnyObject]?
//            for item in items {
//                println( "item[\(item)]" )
//
//            }

//            if let jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? [String: AnyObject] {
//                if let arrayOfResults = jsonDictionary["statuses"] as? [[String:AnyObject]]{
//                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                        trailingClosure(TrendEngineForTicker(tickerSymbol: tickerSymbol,firstJSONBlob: arrayOfResults),nil)
//                    })
//                }
//            }

//            let items = jsonDictionary["items"] as? [String : AnyObject]
//            for item in items {
//                println( "item[\(item)]" )
//            }
//
//            println( "item count[\(items.count)]" )
        }

        return users
    }

//        let items = jsonDictionary["items"] as? [String : AnyObject]
//        println( items.count )


//        if let
//            jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? [String : AnyObject] {
//
////                let    items = jsonDictionary["items"] as? [[String : AnyObject]] {

//println("items[\(items)]" )

//                for item in items {
//
//                    if let
//                        login = item["login"] as? String,
//                        avatarURL = item["avatar_url"] as? String,
//                        htmlURL = item["html_url"] as? String {
//                    let user = User(login: login, avatarURL: avatarURL, htmlURL: htmlURL)
//                        users.append(user)
//                }
//            }
//        }
//        return users
//    }
}