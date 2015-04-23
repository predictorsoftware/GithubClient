//
//  SearchUsersViewController.swift
//  GithubClient
//
//  Created by Gru on 04/22/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

import UIKit

class SearchUsersViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    let imageFetchService       = ImageFetchService()
    var networkController       = NetworkController.sharedNetworkController

    let DBUG                    = NetworkController.sharedNetworkController.DBUG
    var users                   = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView.dataSource = self
        self.searchBar.delegate        = self
    }

    override func viewWillAppear( animated: Bool ) {
        super.viewWillAppear( animated )
//      self.navigationController.delegate = self   // NavigationController
    }

    //            destination.selectionUser = user
    //            (UINavigationController, animationControllerForOperation: UINavigationControllerOperation, forViewController: UIViewController, toViewController: UIViewController) ->UIView
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.delegate = nil
    }

    func searchBarSearchButtonClicked( searchBar: UISearchBar ) {
        if DBUG { println( "searchBarSearchButtonClicked[\(searchBar.text)]" ) }
        searchBar.resignFirstResponder()
        NetworkController.sharedNetworkController.fetchUserBySearchTerm( searchBar.text,
            callback:  { (users, error) -> (Void) in
                self.users = users!
                self.collectionView.reloadData()
            })
    }

    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return true // text.validForURL()
    }

    func collectionView( collectionView: UICollectionView, numberOfItemsInSection section: Int ) -> Int {
        return self.users.count
    }

    func collectionView( collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier( "UserCell", forIndexPath: indexPath ) as UserCell
            cell.imageView.image = nil
        var user = self.users[indexPath.row]

        if  user.avatarImage != nil {
            cell.imageView.image = user.avatarImage
        } else {
            self.imageFetchService.fetchImageForURL( user.avatarURL, imageViewSize: cell.imageView.frame.size, completionHandler: { (downloadedImage) -> (Void) in

                cell.imageView.alpha     = 0
                cell.imageView.transform = CGAffineTransformMakeScale( 1.0, 1.0 )
                user.avatarImage         = downloadedImage

                cell.imageView.image     = downloadedImage

                UIView.animateWithDuration( 0.4, animations: { () -> Void in
                    cell.imageView.alpha = 1
                    cell.imageView.transform = CGAffineTransformMakeScale( 1.0, 1.0 )
                })
            })
        }

        return cell
    }

    func navigationController( navigationController: UINavigationController,
          animationControllerForOperation operation: UINavigationControllerOperation,
                          fromViewController fromVC: UIViewController,
                              toViewController toVC: UIViewController ) -> UIViewControllerAnimatedTransitioning? {

        if fromVC is SearchUsersViewController {
            return ToUserDetailAnimationController()
        } else {
            return nil
        }
    }

    override func prepareForSegue( segue: UIStoryboardSegue, sender: AnyObject? ) {

        if segue.identifier == "USER_CELL" {

            let destination = segue.destinationViewController as UserDetailViewController
            let indexPath   = self.collectionView.indexPathsForSelectedItems().first as NSIndexPath
            let user        = self.users[indexPath.row]

        }
    }

}
