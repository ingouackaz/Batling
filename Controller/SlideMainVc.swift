//
//  SlideMainVc.swift
//  FoodChainS
//
//  Created by Roger Ingouacka on 26/10/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//


class SlideMainVc: AMSlideMenuMainViewController {
//    var _foodchain : FoodChain = FoodChain.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
    //    self.navigationController?.navigationBar.barTintColor =  UIColor(hexString: "#e67e22")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
     //   self.navigationController?.navigationBar.titleTextAttributes = titleDict
    }
    
    override func segueIdentifierForIndexPathInLeftMenu(indexPath: NSIndexPath!) -> String! {
        
        switch (indexPath.section)
        {
        case 0:
            return "selection"
            
        default:
       //     self._foodchain.clearUser()
            return "backHome"
            // do nothing
        }
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    override func leftMenuWidth() -> CGFloat {
        return 300
    }

    override func segueIdentifierForIndexPathInRightMenu(indexPath: NSIndexPath!) -> String! {
        return "selection"
    }

    override func configureLeftMenuButton(button: UIButton) {
       // button
        
        var frame : CGRect = button.frame;

        frame = CGRectMake(0, 0, 25, 13)
        button.frame = frame
        button.backgroundColor = UIColor.clearColor()
        
        
       button.setImage(UIImage(named: "list"), forState: UIControlState.Normal)
        button.tintColor = UIColor.whiteColor()

    }
    
    override func configureSlideLayer(layer: CALayer!) {
        
        layer.shadowColor = UIColor.blackColor().CGColor;
        layer.shadowOpacity = 1;
        layer.shadowOffset = CGSizeMake(0, 0);
        layer.shadowRadius = 5;
        layer.masksToBounds = false;
        
        layer.shadowPath = UIBezierPath(rect: self.view.layer.bounds).CGPath
    }
    
    override func primaryMenu() -> AMPrimaryMenu {
        return AMPrimaryMenuLeft
    }
    
    
    
    
    override func deepnessForLeftMenu() -> Bool {
        return true
    }
}
