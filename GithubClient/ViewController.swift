//
//  ViewController.swift
//  GithubClient
//
//  Created by Gru on 04/10/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let redView = UIView( frame: CGRect(x: 100, y: 100, width: 200, height: 200))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.redView.backgroundColor = UIColor.redColor()
        self.view.addSubview(self.redView)

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

//        UIView.animateWithDuration(1.4, animations: { () -> Void in
//            self.redView.backgroundColor = UIColor.blueColor()
//            self.redView.center = CGPoint( x: 300, y: 300)
//            // or
//            self.redView.center = CGPoint( x: self.redView.center.x, y: 400)
//            }) { (finished) -> Void in
//                self.redView.backgroundColor = UIColor.blueColor()
//        }
//
//// example #3
//        UIView.animateWithDuration( 1.0, delay: 1.0, options: UIViewAnimationOptions.CurveEaseInOut,
//            animations: { () -> Void in
//                self.redView.center = CGPoint( x: self.redView.center.x, y: 400 )
//            }) { (finished) -> Void in
//
//        }
//
//// example #4
//        UIView.animateWithDuration(1.6, delay: 1.0,
//            usingSpringWithDamping: 1.0,
//            initialSpringVelocity: 20.0,
//            options: nil,
//            animations: { () -> Void in
//                self.redView.center = CGPoint(x: self.redView.center.x, y: 400)
//            }) { (finished) -> Void in
//        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

