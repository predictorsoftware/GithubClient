//
//  NetworkController.swift
//  GithubClient
//
//  Created by Gru on 04/10/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//
//  NOTE: https://developer.github.com/v3/oauth/ 
//        When you're setting up OAuth use the link above to docs on OAuth/Web Flow
//
//  -->   Look into 'Singleton' and 'Computed Properties'

import UIKit

class NetworkController {

    //  Singleton / Computed Properties / W3D2.3 7:22
    class var sharedNetworkController : NetworkController {                     // Computed type property
        struct Static {                                                         // Nested Struct
            static let instance : NetworkController = NetworkController()       // Static Properties
        }       // ^^^ makes it so there is only one occurance
        return Static.instance                                                  // Returns the computed property
    }

    var DBUG     : Bool = false
    var EXAMPLE1 : Bool = false

    //   WARNING - These two items should never make it into Github, especially when you're
    //             going to submit this or any other app to the Apple Store.
    // Client ID
    let clientId     = "11c02af80289b9906733"
    // Client Secret
    let clientSecret = "6648ebfc7550fdbd9b375b89da53bbdd4b11f614"

    var urlSession : NSURLSession
    let accessTokenUserDefaultsKey = "accessToken"
    var accessToken : String?
    var accessTokenKeyComponent : String?

    var currentUser = "dakoch"
    var currentUserDetails = [User]()

    let imageQueue = NSOperationQueue()

    // ----------------------------------------------------------------------------------------------
    //  Function: init()
    //
    init() {
        let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        self.urlSession     = NSURLSession( configuration: ephemeralConfig )

        if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey(self.accessTokenUserDefaultsKey) as? String {
            self.accessToken = accessToken
            if DBUG { println( "accessToken[\(self.accessToken)]" ) }
        }
    }

    // ----------------------------------------------------------------------------------------------
    //  Function: getAccessToken()
    //
    func getAccessToken() -> NSString {
        if self.accessToken != nil {
            return self.accessToken!
        } else {
            if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey(self.accessTokenUserDefaultsKey) as? String {
                self.accessToken = accessToken
                if DBUG { println( "accessToken[\(self.accessToken)]" ) }
            } else {
                self.accessToken = nil
            }
            return self.accessToken!
        }
    }

    // ----------------------------------------------------------------------------------------------
    //  Function: getCurrentUserDetails()
    //
//    func getCurrentUserDetails() -> User {
//
//        return currentUserDetails[0]
//    }

    // ----------------------------------------------------------------------------------------------
    //  Function: requestAccessToken()
    //
    func requestAccessToken() {
        if DBUG { println( "NetworkController::requestAccessToken()" ) }
        //         https://github.com/login/oauth/authorize

        let url = "https://github.com/login/oauth/authorize?client_id=\(self.clientId)&scope=user,repo"

        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }

    // ----------------------------------------------------------------------------------------------
    //  Function: getRepositoriesForGivenSearchTerm()        AKA. fetchRepositoriesForSearchTerm()
    //      Info: see http://developer.github.com for GitHub API
    //            Using their 'Search' endpoint, to look for repositories
    //
    // Example: curl https://api.github.com/search/repositories?q=tetris+language:assembly&sort=stars&order=desc
    //
    func getRepositoriesForGivenSearchTerm( searchTerm : String, callback : ( [Repository]?, String? ) -> (Void))  {

        //    let url = NSURL( string: "http://127.0.0.1:3000" )                                          // Phase I
        let url = NSURL( string: "https://api.github.com/search/repositories?q=\(searchTerm)" )           // Phase II

        let dataTask = self.urlSession.dataTaskWithURL( url!, completionHandler: { (data, urlResponse, error ) -> Void in
            if error == nil {
                if self.DBUG { println( "       data[\(data)]" ) }
                println( "urlResponse[\(urlResponse)]" )
                println( "      error[\(error)]" )

                if let response = urlResponse as? NSHTTPURLResponse {

                    switch response.statusCode {
                    case 200...299:
                        var repositories = [Repository]()
                        var errorPtr : NSError?
                        let jsonDictionary = NSJSONSerialization.JSONObjectWithData( data, options: nil, error: &errorPtr ) as [String : AnyObject]

                        if let items = jsonDictionary["items"] as? [[String : AnyObject]] {
                            var n = 0
                            for item in items {
                                let repo = Repository( jsonRepository: item )
                                repositories.append( repo )
                                if self.DBUG { println( "\n item[\(n)] \(item)" ) }
                                n++
                            }
                        }

                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in callback( repositories, "" ) })

                        if self.DBUG {
                            println( "\n" )
                            println( "Repositories --> \(repositories) " );
                            println( "count --> \(repositories.count) " );
                            if repositories.count > 0 {
                                println( repositories[0].author )
                            }
                        }

                    default:
                        callback( nil, "Error occured while retrieving items in the repository based on search term: \(searchTerm)" )
                    }
                }
            }
        })
        dataTask.resume()
    }

    // ----------------------------------------------------------------------------------------------
    //     Function: getUserBySearchTerm()
    //  Description: This method will find the 'user' which matches the given 'searchTerm'.
    //
    //  https://api.github.com/search/users?q=user:dakoch
    //                                ^^^^^^^^^^^^   gets you an exact match to 'dakoch'.
    //
    func getUserBySearchTerm(searchTerm: String, callback: ([User]?, String?) -> ()) {

        println( "currentUserDetails() : \(self.currentUserDetails)" )

        //URL: with authorization
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: "https://api.github.com/search/users?q=user:\(searchTerm)")!)

        //Execute request.
        let dataTask = urlSession.dataTaskWithRequest(urlRequest, completionHandler: { (jsonData, urlResponse, error) -> Void in
            if error == nil {
                let response = urlResponse as NSHTTPURLResponse
                switch response.statusCode {
                case 200...299:
                    //Parse JSON response.

                    var errorPointer: NSError?
                    if let jsonDictonary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &errorPointer) as? [String : AnyObject] {
                        var n = 0
                        if let items = jsonDictonary["items"] as? [[String : AnyObject]] {
                            // Should only be one 'item'
                            for item in items {
                                if self.DBUG { println( "[\(n)] item[\(item)]" ) }
                                self.currentUserDetails.append(User(userJSONDictionary: item))
                                n++
                            }
                        }
                    }

                    // Return to main queue.
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        callback(self.currentUserDetails, nil)
                    })
                default:
                    callback(nil, "Error retrieving user by search term")
                }
            }
        })
        dataTask.resume()
    }

    // ----------------------------------------------------------------------------------------------
    //     Function: getUsersBySearchTerm()
    //  Description: This method will find the list of 'userS' based on the given 'searchTerm'
    //
    //  https://api.github.com/search/users?q=dakoch
    //                                ^^^^^  gets you a wild card search for 'dakoch'
    //
    func getUsersBySearchTerm(searchTerm: String, callback: ([User]?, String?) -> ()) {

        //URL: with authorization
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: "https://api.github.com/search/users?q=\(searchTerm)")!)
//      urlRequest.setValue("token \(accessToken!)", forHTTPHeaderField: "Authorization")
//      urlRequest.setValue("token \(getAccessToken())", forHTTPHeaderField: "Authorization")

        //Execute request.
        let dataTask = urlSession.dataTaskWithRequest(urlRequest, completionHandler: { (jsonData, urlResponse, error) -> Void in
            if error == nil {
                let response = urlResponse as NSHTTPURLResponse
                switch response.statusCode {
                case 200...299:
                    //Parse JSON response.
                    var users = [User]()
                    var errorPointer: NSError?
                    if let jsonDictonary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &errorPointer) as? [String : AnyObject] {
                        var n = 0
                        if let items = jsonDictonary["items"] as? [[String : AnyObject]] {
                            for item in items {
                                if self.DBUG { println( "[\(n)] item[\(item)]" ) }
                                users.append(User(userJSONDictionary: item))
                                n++
                            }
                        }
                    }

                    // Return to main queue.
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        callback(users, nil)
                    })
                default:
                    callback(nil, "Error retrieving user by search term")
                }
            }
        })
        dataTask.resume()
    }

    // ----------------------------------------------------------------------------------------------
    //  Function: getRepositoriesForGivenSearchTerm()        AKA. fetchRepositoriesForSearchTerm()
    //      Info: see http://developer.github.com for GitHub API
    //            Using their 'Search' endpoint, to look for repositories
    //
    // Example: curl https://api.github.com/search/repositories?q=tetris+language:assembly&sort=stars&order=desc
    //
    func getRepositoriesForGivenUser( searchTerm : String, callback : ( [Repository]?, String? ) -> (Void))  {

        //    let url = NSURL( string: "http://127.0.0.1:3000" )                                      // Phase I
        let url = NSURL( string: "https://api.github.com/search/repositories?q=user:\(searchTerm)" )  // Phase II

        let dataTask = self.urlSession.dataTaskWithURL( url!, completionHandler: { (data, urlResponse, error ) -> Void in
            if error == nil {
                if self.DBUG { println( "       data[\(data)]" ) }
                println( "urlResponse[\(urlResponse)]" )
                println( "      error[\(error)]" )

                if let response = urlResponse as? NSHTTPURLResponse {

                    switch response.statusCode {
                    case 200...299:
                        var repositories = [Repository]()
                        var errorPtr : NSError?
                        let jsonDictionary = NSJSONSerialization.JSONObjectWithData( data, options: nil, error: &errorPtr ) as [String : AnyObject]

                        if let items = jsonDictionary["items"] as? [[String : AnyObject]] {
                            var n = 0
                            for item in items {
                                let repo = Repository( jsonRepository: item )
                                repositories.append( repo )
                                if self.DBUG { println( "\n item[\(n)] \(item)" ) }
                                n++
                            }
                        }

                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in callback( repositories, "" ) })

                        if self.DBUG {
                            println( "\n" )
                            println( "Repositories --> \(repositories) " );
                            println( "count --> \(repositories.count) " );
                            if repositories.count > 0 {
                                println( repositories[0].author )
                            }
                        }

                    default:
                        callback( nil, "Error occured while retrieving items in the repository based on search term: \(searchTerm)" )
                    }
                }
            }
        })
        dataTask.resume()
    }

    // ----------------------------------------------------------------------------------------------
    //  Function: getRepositoriesForMe()
    //      Info: see http://developer.github.com for GitHub API
    //            Using their 'Search' endpoint, to look for repositories
    //
    // Example:      https://api.github.com/search/repositories?q=user:\(userName)")!)
    //
    func getRepositoriesForMe( callback : ( [Repository]?, String? ) -> (Void))  {

        //  let url = NSURL( string: "http://127.0.0.1:3000" )                                     // Phase I
        //  let url = NSURL( string: "https://api.github.com/search/repositories?q=user:dakoch" )  // Phase II
        let url = NSURL( string: "https://api.github.com/search/repositories?q=user:dakoch" )      // Phase III

        let dataTask = self.urlSession.dataTaskWithURL( url!, completionHandler: { (data, urlResponse, error ) -> Void in
            if error == nil {
                if self.DBUG { println( "       data[\(data)]" ) }
                println( "urlResponse[\(urlResponse)]" )
                println( "      error[\(error)]" )

                if let response = urlResponse as? NSHTTPURLResponse {

                    switch response.statusCode {
                    case 200...299:
                        var repositories = [Repository]()
                        var errorPtr : NSError?
                        let jsonDictionary = NSJSONSerialization.JSONObjectWithData( data, options: nil, error: &errorPtr ) as [String : AnyObject]

                        if let items = jsonDictionary["items"] as? [[String : AnyObject]] {
                            var n = 0
                            for item in items {
                                let repo = Repository( jsonRepository: item )
                                repositories.append( repo )
                                if self.DBUG { println( "\n item[\(n)] \(item)" ) }
                                n++
                            }
                        }

                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in callback( repositories, "" ) })

                        if self.DBUG {
                            println( "\n" )
                            println( "Repositories --> \(repositories) " );
                            println( "count --> \(repositories.count) " );
                            if repositories.count > 0 {
                                println( repositories[0].author )
                            }
                        }

                    default:
                        callback( nil, "Error occured while retrieving items in the repository based on the user's id." )
                    }
                }
            }
        })
        dataTask.resume()
    }

    // ----------------------------------------------------------------------------------------------
    //     Function: getAvatarImageForURL()
    //
    func getAvatarImageForURL( url : String, completionHandler : (UIImage) -> (Void)) {

        let url = NSURL(string: url)

        self.imageQueue.addOperationWithBlock { () -> Void in
            let imageData = NSData(contentsOfURL: url!)
            let image = UIImage(data: imageData!)

            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completionHandler(image!)
            })
        }
    }

    // ----------------------------------------------------------------------------------------------
    //     Function: handleCallbackURL()
    //  Discription: Dealing w/ OAuth
    //
    func handleCallbackURL( url: NSURL ) {

        println( "NetworkController::handleCallbackURL[\(url)]" )
        let code = url.query
        println( "code\(code)" )

        // This is an example of getting thru GITHUB's security.
        // This is one way (EXAMPLE#1) you can pass back info in a POST, via passing items as parameters in the URL!
        if EXAMPLE1 {

            let oauthURL = "https://github.com/login/oauth/access_token?\(code!)" +
                           "&client_id=\(self.clientId)" +
                           "&client_secret=\(self.clientSecret)"

            let postRequest = NSMutableURLRequest( URL: NSURL( string: oauthURL)!)
                postRequest.HTTPMethod = "POST"     // PUT, POST, ...

            let dataTask = self.urlSession.dataTaskWithRequest( postRequest, completionHandler: {
                (data, response, error) -> Void in
                    println( "\(response)" )
                })
            dataTask.resume()

        } else {
        //
        // This is the 2nd way you can pass back info with a POST!
        // This example is passing back into in the BODY of the HTTP Request

            let bodyString = "\(code!)&client_id=\(self.clientId)&client_secret=\(self.clientSecret)"
            let bodyData   = bodyString.dataUsingEncoding( NSASCIIStringEncoding, allowLossyConversion : true )
            let length     = bodyData!.length
            let postRequest = NSMutableURLRequest( URL: NSURL( string: "https://github.com/login/oauth/access_token" )!)

            postRequest.HTTPMethod = "POST"
            postRequest.setValue("\(length)", forHTTPHeaderField: "Content-Length" )
            postRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type" )
            postRequest.HTTPBody = bodyData

            let dataTask   = self.urlSession.dataTaskWithRequest(postRequest, completionHandler: {
                (data, response, error) -> Void in
                if error == nil {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 200...299:
                            let tokenResponse = NSString( data: data, encoding: NSASCIIStringEncoding)
                            println(tokenResponse)

                            let accessTokenKey           = tokenResponse?.componentsSeparatedByString("&").first as String
                            let accessTokenValue         = accessTokenKey.componentsSeparatedByString("=").last
                            println(accessTokenValue!)

                            self.accessToken             = accessTokenValue
                            self.accessTokenKeyComponent = accessTokenKey

                            // Save 'accessToken' in 'User Defaults'
                            NSUserDefaults.standardUserDefaults().setObject( self.accessToken,
                                                                     forKey: self.accessTokenKeyComponent!)
                            NSUserDefaults.standardUserDefaults().synchronize()
                        default:
                            println("Default Case, Error retrieving the access token.")
                        }
                    }
                }

                println(response)
            })
            dataTask.resume()
        }
    }


//    items": [
//    {
//      "login": "brad",
//      "id": 1614,
//      "avatar_url": "https://avatars.githubusercontent.com/u/1614?v=3",
//      "gravatar_id": "",
//      "url": "https://api.github.com/users/brad",
//      "html_url": "https://github.com/brad",
//      "followers_url": "https://api.github.com/users/brad/followers",
//      "following_url": "https://api.github.com/users/brad/following{/other_user}",
//      "gists_url": "https://api.github.com/users/brad/gists{/gist_id}",
//      "starred_url": "https://api.github.com/users/brad/starred{/owner}{/repo}",
//      "subscriptions_url": "https://api.github.com/users/brad/subscriptions",
//      "organizations_url": "https://api.github.com/users/brad/orgs",
//      "repos_url": "https://api.github.com/users/brad/repos",
//      "events_url": "https://api.github.com/users/brad/events{/privacy}",
//      "received_events_url": "https://api.github.com/users/brad/received_events",
//      "type": "User",
//      "site_admin": false,
//      "score": 94.950485
//    },
//
//    let urlRequest = NSMutableURLRequest(URL: NSURL(string: "https://api.github.com/search/users?q=\(searchTerm)")!)
//    urlRequest.setValue("token \(accessToken!)", forHTTPHeaderField: "Authorization")
    //Function: Fetch user information from GitHub.

    func fetchUserBySearchTerm(searchTerm: String, callback: ([User]?, String?) -> ()) {
        //URL: with authorization
        //let urlRequest = NSMutableURLRequest(URL: NSURL(string: "https://api.github.com/search/users?q=\(searchTerm)")!)
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: "https://api.github.com/search/users?q=dakoch")!)
            urlRequest.setValue("token \(accessToken!)", forHTTPHeaderField: "Authorization")

        //Execute request.
        let dataTask = urlSession.dataTaskWithRequest(urlRequest, completionHandler: { (jsonData, urlResponse, error) -> Void in
            if error == nil {
                let response = urlResponse as NSHTTPURLResponse
                switch response.statusCode {
                case 200...299:
                    //Parse JSON response.
                    var users = [User]()
                    var errorPointer: NSError?
                    if let jsonDictonary = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &errorPointer) as? [String : AnyObject] {
                        if let items = jsonDictonary["items"] as? [[String : AnyObject]] {
                            for item in items {
                                users.append(User(userJSONDictionary: item))
                            } //end for
                        } //end if
                    } //end if

                    //Return to main queue.
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        callback(users, nil)
                    }) //end closure
                default:
                    callback(nil, "Error retrieving user by search term")
                } //end switch
            } //end if
        }) //end closure
        dataTask.resume()
    } //end func
    
    // ----------------------------------------------------------------------------------------------
    //  Function: getUserDetailInformation() 
    func getUserDetailInformation( userName : String, callback : ([AnyObject]?, String) -> (Void)) {

        let url = NSURL( string: "https://api.github.com/search/users?q=user:\(userName)" )

//        let dataTask = self.urlSession.dataTaskWithURL( url!, completionHandler: { (data, urlResponse, error ) -> Void in
//                println( "User Detail" )
//        }
//
//        dataTask.resume()
    }

    // ----------------------------------------------------------------------------------------------
    //  Function: fetchRepositoriesForSearchTerm() - ) obsolete !
    //      Note: Replaced this method w/ getRepositoriesForGivenSearchTerm()
    //      Info: see http://developer.github.com for GitHub API
    //            Using their 'Search' endpoint, to look for repositories
    func fetchRepositoriesForSearchTerm( searchTerm : String, callback : ([AnyObject]?, String) -> (Void)) {

        let url = NSURL( string: "http://127.0.0.1:3000" )
        let dataTask = self.urlSession.dataTaskWithURL( url!, completionHandler: { (datat, urlResponse, error) -> Void in
            if error == nil {
                println( urlResponse )
            }
        })
        dataTask.resume()
    }
}