//
//  SearchRepoViewCell.swift
//  GithubClient
//
//  Created by Gru on 04/12/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

import UIKit

class SearchRepoViewCell: UITableViewCell {


    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var reproHtmlURL: UILabel!
    @IBOutlet weak var repoAuthor: UILabel!
    @IBOutlet weak var repoId: UILabel!
    @IBOutlet weak var repoCreatedAt: UILabel!


//    @IBOutlet weak var labelAuthor: UILabel!

    //Function: Set up Nib.
    override func awakeFromNib() {
        //Super:
        super.awakeFromNib()

//      self.repoName.font      = UIFont(name: "Helvetica Neue-Black", size: 12.0)
        self.repoAuthor.font    = UIFont(name: "Helvetica Neue", size: 10.0)
        self.reproHtmlURL.font  = UIFont(name: "Helvetica Neue", size: 10.0)
        self.repoId.font        = UIFont(name: "Helvetica Neue", size: 10.0)
        self.repoCreatedAt.font = UIFont(name: "Helvetica Neue", size: 10.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}