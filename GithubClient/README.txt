//
//  README.txt
//  GithubClient
//
//  Created by Gru on 04/10/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

//  Week 3 - Github Client
//  Due Jan 25 by 8am  Points 100  Submitting a website url
//  ---------------------------------------------------------------------------------------------------------
//  Monday
//
// [x]  Create a main menu to our app using a static table view
// [x]  Create a network controller and implement a method that fetches repositories based on a search term. Instead of pointing the request at the Actual Github API server, use the node script (server.js) provided in the class repository and point the request at your own machine ("http://127.0.0.1:3000"). Since our apps aren't authenticated with Github yet we will hit the rate limit after 5 unauthenticated calls from our IP. The node script is called server.js. Just run it with your node command in terminal.
// [x]  Create a RepositoryViewController and parse through the JSON returned fromm the server into struct model objects and display the results in a table view.
// [x]  Add a UISearchBar to your RepositoryViewController and fire your network call from there. Tomorrow once we are authenticated we will actually use that search term to get the right data back.

TODO :
    Install node.js (Mine was downloaded in the Javascript F2 class)
    Cntrl-C to quit

    Go to 'xTerm',
    cd to folder where 'server.js' is located
    On the command line:    node server.js

//  ---------------------------------------------------------------------------------------------------------
//  Tuesday
//
// [x]  Implement an OAuth workflow in your app that successfully lets the user authenticate with your app.
// [x]  Implement a UISearchBar on your repo search view controller and modify your repo search fetch method on your network controller to use the search bar’s text. Be sure to only be making authenticated network calls using your oath token!
// [x]  Display the repo’s they searched for a in the table view
// [x]  Implement 'user defaults' to store the authorization token, so it only does the OAuth process once.
// [x]  Convert your network controller to a singleton

//  ---------------------------------------------------------------------------------------------------------
//  Wednesday
//
// [X]  Create a UserSearchViewController that searches for users, similar to how we are already searching for repositories. Instead of a table view, use a collection view to display the users avatar image
// [x]  Upon clicking on a cell, , and transition the image clicked on to a UserDetailViewController page that has their picture, name, and whatever other info you want pulled from their API.
// [ ]  Implement a custom transition to UserDetailViewController

//  ---------------------------------------------------------------------------------------------------------
//  Thursday

// [ ]  Implement Regex in your app. Use it to validate the characters the user types into the search bar. Extend String with this functionality.
// [ ]  Implement WKWebView in your app. When a user clicks on a repo, show their repo's web page with WKWebView.

//  ---------------------------------------------------------------------------------------------------------
//  Friendship Friday

// [o]  Pair programming rules:

// [o]  You must be working in a pair of 2 at all times. The best pairs have similar experience levels. Choose a new partner each week!
// [o]  One person will be typing (driving), but the other person needs to actively contribute. Each line of code you guys write should be discussed and decided upon. Keep an open mind, and if you guys disagree on something, try one way first and see if it works, if it doesn't try the other way.
// [o]  Don't physically harm your partner.
// [o]  Switch roles every half hour.
// [x]  Remember to high-five when you guys do something awesome. See http://en.wikipedia.org/wiki/High_five (Links to an external site.) for more info on this social ritual.
// [o]  The friendship friday challenges can be submitted jointly, if the work you did is on a different person's project, please note that in your homework submission. If the feature(s) you guys built is so awesome you just have to have it in your own project, copy it over.

//  ---------------------------------------------------------------------------------------------------------
//  Challenges:

// [ ]  Implement the 'My Profile' view controller in your app. This should display info about the currently logged in user (their bio, if they are hirable, their count of public and private repos, etc).
// [ ]  Implement a way for the logged in user to create a repo from the app. Good luck and god bless.
// [ ]  Implement a way for the user to update their bio.
// [ ]  Implement a custom transition to UserDetailViewController



//  ---------------------------------------------------------------------------------------------------------

Restful API
Web APIs
NSURLSession class / Delegates / Callbackes


