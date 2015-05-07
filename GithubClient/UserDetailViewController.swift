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

        self.userName.text           = selectedUser.name
        self.userURL.text            = selectedUser.htmlURL
        self.userAvatarURL.text      = selectedUser.avatarURL

        var theImage : UIImage!

        var url : String?
            url = "\(self.selectedUser.avatarURL)"

            self.networkController.getAvatarImageForURL( url!, completionHandler: { (image) -> (Void) in
                self.imageView.image = image
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func searchForUserInfo() {

    } 

}
