//
//  BatlingSingleton.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-15.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit
import Parse

class BatlingSingleton {
    
    static let sharedInstance = BatlingSingleton()
    var _loadingHUD : MBProgressHUD =  MBProgressHUD()
    var _homeCacheThumbImage : [FeedImageCell:UIImage] = [FeedImageCell:UIImage]()
    var _homeCacheThumbImageIndexPath : [String:UIImage] = [String:UIImage]()
    var _xoutstandingSectionHeaderQueries : [FeedTextCell:PFObject] = [FeedTextCell:PFObject]()
    var _outstandingSectionHeaderQueries : [FeedImageCell:PFObject] = [FeedImageCell:PFObject]()
    var _woutstandingSectionHeaderQueries : [GlobalFeedCell:PFObject] = [GlobalFeedCell:PFObject]()

//
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

    func logout(){
        
        // clear cache
     //   PAPCache.sharedCache().clear()
        
   //     NSUserDefaults.standardUserDefaults().removeObjectForKey(kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey)
    //    NSUserDefaults.standardUserDefaults().synchronize()
        // Clear all caches
        PFUser.logOutInBackgroundWithBlock { (error) -> Void in
            
        }
        PFQuery.clearAllCachedResults()
        
    }
    
    
    func startLoading(view:UIView, text:String){
        _loadingHUD   = MBProgressHUD.showHUDAddedTo(view, animated: true)
        _loadingHUD.labelText = text
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

}

