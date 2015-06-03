//
//  BatlingSingleton.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-15.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit


class BatlingSingleton {
    
    static let sharedInstance = BatlingSingleton()
   // var _loadingHUD : MBProgressHUD =  MBProgressHUD()
    var _homeCacheThumbImage : [FeedImageCell:UIImage] = [FeedImageCell:UIImage]()
    var _homeCacheThumbImageIndexPath : [String:UIImage] = [String:UIImage]()

    var _seletectedMenuIndex : Int = -1
 //   var _outstandingSectionHeaderQueries : [FeedCell:PFObject] = [FeedCell:PFObject]()
    var _FeedCellHeight : CGFloat = 520
    
    var _firstAppear : Bool = true
    
    init() {
        var iOSDeviceScreenSize : CGSize = UIScreen.mainScreen().bounds.size

        // iPhone 4e
        if (iOSDeviceScreenSize.height == 480){
            _FeedCellHeight = 470

        }
        else if(iOSDeviceScreenSize.height == 568){
            _FeedCellHeight = 470
        }
        else if(iOSDeviceScreenSize.height == 667){
            _FeedCellHeight = 520

        }
        else {
            _FeedCellHeight = 565
  
        }
        
        println("AAA");
    }

    /*
    func startLoading(view:UIView){
        _loadingHUD   = MBProgressHUD.showHUDAddedTo(view, animated: true)
        _loadingHUD.labelText = ""
        _loadingHUD.show(true)
    }
    
    func stopLoading(){
        _loadingHUD.hide(true)
    }
    
    func displayAlertWithText(vc:UIViewController,text:String){
        let myAlert: UIAlertController = UIAlertController(title: "Erreur", message:text,
            preferredStyle: .Alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        vc.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func logout(){
    
        // clear cache
        PAPCache.sharedCache().clear()
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey(kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        // Clear all caches
        PFQuery.clearAllCachedResults()
        
        
        /*
        // clear cache
        [[PAPCache sharedCache] clear];
        
        // clear NSUserDefaults
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsCacheFacebookFriendsKey];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // Unsubscribe from push notifications by removing the user association from the current installation.
        [[PFInstallation currentInstallation] removeObjectForKey:kPAPInstallationUserKey];
        [[PFInstallation currentInstallation] saveInBackground];
        
        // Clear all caches
        [PFQuery clearAllCachedResults];
        
        // Log out
        [PFUser logOut];
        [FBSession setActiveSession:nil];
        */
    }
   */
}

