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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
