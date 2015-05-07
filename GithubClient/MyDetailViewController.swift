//
//  MyDetailViewController.swift
//  GithubClient
//
//  Created by Gru on 05/05/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

import UIKit

class MyDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userAvatarURL: UILabel!
    @IBOutlet weak var userURL: UILabel!
    @IBOutlet weak var userName: UILabel!

    let imageFetchService       = ImageFetchService()
    var networkController       = NetworkController.sharedNetworkController

    let DBUG                    = NetworkController.sharedNetworkController.DBUG

    var users                   = [User]()
    var user                    = [User]()
    var userId                  = ""

    var selectedUser : User!

    override func viewDidLoad() {
        super.viewDidLoad()

        getUserData( "dakoch" )
            if DBUG { println( self.selectedUser ) }

        if (self.selectedUser != nil) {
            self.userName.text       = selectedUser.name
            self.userURL.text        = selectedUser.htmlURL
            self.userAvatarURL.text  = selectedUser.avatarURL

            var theImage : UIImage!

            var url : String?
                url = "\(self.selectedUser.avatarURL)"

            self.networkController.getAvatarImageForURL( url!, completionHandler: { (image) -> (Void) in
               
                 self.imageView.image = image
            })
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getUserData( userSearchTerm: NSString ) {

        if networkController.currentUserDetails.count > 0 {
            print( "getUserData() : \(networkController.currentUserDetails[0])" )
            self.selectedUser = self.networkController.currentUserDetails[0]
        }

        var userData = [User]()
        NetworkController.sharedNetworkController.getUserBySearchTerm( userSearchTerm,
            callback:  { (userData, error) -> (Void) in
                self.user = userData!
        })
        if DBUG { println( "getUserData[\(self.user)]" ) }
    }

    override func prepareForSegue( segue: UIStoryboardSegue, sender: AnyObject? ) {

        if segue.identifier == "DETAIL_USER" {  //  DETAIL_USER   USER_CELL

            let destination     = segue.destinationViewController as MyDetailViewController
//          let indexPath       = self.collectionView.indexPathsForSelectedItems().first as NSIndexPath
            destination.selectedUser = self.users[0]

            if DBUG { println( "accessToken[\(self.users[0].avatarURL)] [\(destination.selectedUser.avatarURL)]" ) }
            if DBUG { println( "accessToken[\(self.users[0].htmlURL)] [\(destination.selectedUser.htmlURL)]" ) }
            if DBUG { println( "accessToken[\(self.users[0].name)] [\(destination.selectedUser.name)]" ) }
            if DBUG { println( "accessToken[\(self.users[0].avatarImage)] [\(destination.selectedUser.avatarImage)]" ) }
            
        }
    }


}
