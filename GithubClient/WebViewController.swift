//
//  Web.swift
//  GithubClient
//
//  Created by Gru on 04/16/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//


import UIKit
import WebKit

class WebViewController: UIViewController {

    let webView = WKWebView()


    override func loadView() {
        self.view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://github.com/dakoch")!))

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
