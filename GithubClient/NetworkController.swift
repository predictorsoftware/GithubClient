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

    //  Singleton / Computed Properties / W3D2.3 7:22
    class var sharedNetworkController : NetworkController {                     // Computed type property
        struct Static {                                                         // Nested Struct
            static let instance : NetworkController = NetworkController()       // Static Properties
        }       // ^^^ makes it so there is only one occurance
        return Static.instance                                                  // Returns the computed property
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

    //
    //  Discription: Dealing w/ OAuth
    //
    func handleCallbackURL( url: NSURL ) {

        println( "NetworkController::handleCallbackURL[\(url)]" )
        let code = url.query
        println( "code\(code)" )

        // This is an example of getting thru GITHUB's security.
        // This is one way you can pass back info in a POST, via passing items as parameters in the URL!
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

            let bodyString  = "\(code!)&client_id=\(self.clientId)&client_secret=\(self.clientSecret)"
            let bodyData    = bodyString.dataUsingEncoding( NSASCIIStringEncoding, allowLossyConversion : true )
            let length      = bodyData!.length
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