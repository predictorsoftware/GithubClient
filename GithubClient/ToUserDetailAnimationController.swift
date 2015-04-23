//
//  ToUserDetailAnimationController.swift
//  GithubClient
//
//  Created by Gru on 04/22/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

import UIKit

class ToUserDetailAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    // Set total transition time... from 'start' to 'finish'
    let transitionDurationInterval : NSTimeInterval = 0.4

    func transitionDuration( transitionContext : UIViewControllerContextTransitioning ) -> NSTimeInterval {
        return transitionDurationInterval
    }

    func animateTransition( transitionContext : UIViewControllerContextTransitioning ) {

        let fromVC = transitionContext.viewControllerForKey( UITransitionContextFromViewControllerKey ) as SearchUsersViewController

        let toVC   = transitionContext.viewControllerForKey( UITransitionContextToViewControllerKey ) as UserDetailViewController

        let containerView = transitionContext.containerView()

        toVC.view.alpha = 0
        containerView.addSubview( toVC.view )


        let selectedIndexPath = fromVC.collectionView.indexPathsForSelectedItems().first as NSIndexPath
        let userCell = fromVC.collectionView.cellForItemAtIndexPath(selectedIndexPath) as UserCell
        let snapShot = userCell.imageView.snapshotViewAfterScreenUpdates(false)
        userCell.hidden = true
        snapShot.frame = containerView.convertRect(userCell.imageView.frame, fromCoordinateSpace: userCell.imageView.superview!)
        containerView.addSubview(snapShot)
        toVC.view.layoutIfNeeded()

        let duration = self.transitionDuration( transitionContext )

        UIView.animateWithDuration( duration, animations: { () -> Void in toVC.view.alpha = 1

            let frame = containerView.convertRect( toVC.imageView.frame, fromView: toVC.view )
            snapShot.frame = frame

        }) { (finished) -> Void in

            // Clean up
            toVC.imageView.hidden = false
            userCell.imageView.hidden = false
            snapShot.removeFromSuperview()
            transitionContext.completeTransition( true )
        }
    }

}
