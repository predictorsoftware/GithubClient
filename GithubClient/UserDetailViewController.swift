//
//  UserDetailViewController.swift
//  GithubClient
//
//  Created by Gru on 04/22/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userAvatarURL: UILabel!
    @IBOutlet weak var userURL: UILabel!

    let imageFetchService       = ImageFetchService()
    var networkController       = NetworkController.sharedNetworkController

    let DBUG                    = NetworkController.sharedNetworkController.DBUG

    var users                   = [User]()
    var user                    = [User]()
    var userId                  = ""

    var selectedUser : User!

    override func viewDidLoad() {
        super.viewDidLoad()

//      self.imageView.image    = selectedUser.avatarImage
        self.userName.text           = selectedUser.name
        self.userURL.text            = selectedUser.htmlURL
        self.userAvatarURL.text      = selectedUser.avatarURL

        var theImage : UIImage!
//      var url = NSURL( string: "\(self.userAvatarURL.text)" )

        var url : String?
            url = "\(self.selectedUser.avatarURL)"

//        var url = NSString( self.userAvatarURL.text )
//        if self.imageView == nil  {
            self.networkController.getAvatarImageForURL( url!, completionHandler: { (image) -> (Void) in
                self.imageView.image = image
            })
//        }

////        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
//            cell.imageView.image = nil
//            var user = self.users[indexPath.row]
//            if user.avatarImage == nil {
//                NetworkController.sharedNetworkController.getAvatarImageForURL( user.avatarURL, completionHandler: { (image) -> (Void) in
//                    cell.imageView.image = image
//                    user.avatarImage = image
//                    self.users[indexPath.row] = user
//                })
//            } else {
//                cell.imageView.image = user.avatarImage
//            }
//            return cell
//        }



//        self.networkController.getAvatarImageForURL( url : String, completionHandler: <#(UIImage) -> (Void)##(UIImage) -> (Void)#>) in
//            println( "userAvatarURL[\(self.userAvatarURL.text)]" )
//        }
//
//
//
//        self.networkController.getRepositoriesForGivenSearchTerm( searchBar.text, callback: { ( repos, NilLiteralConvertible) -> () in
//            println( "repositories[\(repos)]" )
//            if repos != nil {
//                self.repositories = repos!
//            }
//            self.tableView.reloadData()
//        })


        // Do any additional setup after loading the view.

    //    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    //    self.networkController = appDelegate.networkController

    //  getUserDetailInformation( userId )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func searchForUserInfo() {

//        let repos   = [Repository]()
//        //Search repositories.
//        self.networkController.getUserDetailInformation( userId, callback: { ( repos, NilLiteralConvertible) -> () in
//            println( "repositories[\(repos)]" )
//            if repos != nil {
//
//            }
//
//        })

    } 

}
