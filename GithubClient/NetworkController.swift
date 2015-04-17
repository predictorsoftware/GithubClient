//
//  NetworkController.swift
//  GithubClient
//
//  Created by Gru on 04/10/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

import UIKit

class NetworkController {

    var DBUG : Bool = false

    //   WARNING - These two items should never make it into Github, especially when you're
    //             going to submit this or any other app to the Apple Store.
    // Client ID
    let clientId     = "11c02af80289b9906733"
    // Client Secret
    let clientSecret = "6648ebfc7550fdbd9b375b89da53bbdd4b11f614"

    var urlSession : NSURLSession
    let accessTokenUserDefaultsKey = "accessToken"
    var accessToken : String?

    //singleton
    class var sharedNetworkController : NetworkController {
        struct Static {
            static let instance : NetworkController = NetworkController()
        }
        return Static.instance
    }

    init() {
        let ephemeralConfig = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        self.urlSession     = NSURLSession( configuration: ephemeralConfig )

        if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey(self.accessTokenUserDefaultsKey) as? String {
            self.accessToken = accessToken
        }
    }

    func requestAccessToken() {
        if DBUG { println( "NetworkController::requestAccessToken()" ) }

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
        let url = NSURL( string: "https://api.github.com/search/repositories?q=\(searchTerm)" )     // Phase II

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
                                println( "\n item[\(n)] \(item)" )
                                n++
                            }
                        }

                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in callback( repositories, "" ) })

                        println( "\n" )
                        println( "Repositories --> \(repositories) " );
                        println( "count --> \(repositories.count) " );
                        if repositories.count > 0 {
                            println( repositories[0].author )
                        }

                    default:
                        callback( nil, "Error occured while retrieving items in the repository based on search term: \(searchTerm)" )
                    }
                }
            }
        })
        dataTask.resume()
    }

    func handleCallbackURL( url: NSURL ) {

        println( "NetworkController::handleCallbackURL[\(url)]" )
        let oauthURL = url.query
        println( "code\(oauthURL)" )

        let baseURL = "https://github.com/login/oauth/access_token?\(oauthURL!)&client_id=\(self.clientId)&client_secret=\(self.clientSecret)"

        let postRequest = NSMutableURLRequest( URL: NSURL( string: oauthURL!)!)
        postRequest.HTTPMethod = "POST"

        let dataTask = self.urlSession.dataTaskWithRequest(postRequest, completionHandler: {
            (data, response, error) -> Void in
            println( "\(data)" )
        })
        dataTask.resume()
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