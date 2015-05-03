//
//  SearchForUserReposViewController.swift
//  GithubClient
//
//  Created by Gru on 04/21/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

import UIKit

class SearchForUserReposViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {


    @IBOutlet weak var searchTerm: UISearchBar!
    @IBOutlet weak var tableView:  UITableView!

    var networkController = NetworkController.sharedNetworkController
    let DBUG : Bool       = NetworkController.sharedNetworkController.DBUG

    var repositories      = [Repository]()           // Results of repository search

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib( UINib( nibName: "SearchRepoViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CELL_REPO" )
        tableView.dataSource            = self
        tableView.delegate              = self

        tableView.estimatedRowHeight    = 100
        tableView.rowHeight             = UITableViewAutomaticDimension

        searchTerm.delegate             = self

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkController = appDelegate.networkController

    }

    override func viewDidAppear(animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView( tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if DBUG { println( "repository count[\(repositories.count)]" ) }
        return repositories.count
    }

    // ---------------------------------------------------------------------------------------
    //  Function: tableView
    //      Type: cellForRowAtIndexPath
    //
    func tableView( tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath ) -> UITableViewCell {

        println( "indexPath[\(indexPath)]" )
        println( "indexPathIndex[\(indexPath.row)]" )

        let repoCell  = tableView.dequeueReusableCellWithIdentifier( "CELL_REPO", forIndexPath: indexPath ) as SearchRepoViewCell
        if (repoCell.repoName.text != nil)  {
            println( "SearchMyReposViewController::tableView[\(repoCell.repoName.text)]" )
        } else {
            println( "Trouble in SearchMyReposViewController::tableView" )
        }

        let repoEntry = repositories[indexPath.row]

        repoCell.repoName.text      = repoEntry.name
        repoCell.repoAuthor.text    = "\(repoEntry.author)(\(repoEntry.id))"
        repoCell.reproHtmlURL.text  = repoEntry.htmlURL
        repoCell.repoCreatedAt.text = repoEntry.createdAt

        return repoCell
    }

    func searchBarSearchButtonClicked( searchBar: UISearchBar) {

        println( "searchBar[\(searchBar.text)]" )
        println( "searchTerm[\(searchTerm.text)]" )

        var text    = searchBar.text
        if text.validate() {

            let repos   = [Repository]()
            //Search repositories.
            self.networkController.getRepositoriesForGivenUser( searchBar.text, callback: { ( repos, NilLiteralConvertible) -> () in
                println( "repositories[\(repos)]" )
                if repos != nil {
                    self.repositories = repos!
                }
                self.tableView.reloadData()
            })
            //Dismiss keyboard.
            searchBar.resignFirstResponder()
        } else {
            println( "Error: Bad Search term, Please try again!" )
        }
    }
}
