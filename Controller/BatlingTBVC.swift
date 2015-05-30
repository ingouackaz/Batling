//
//  BatlingTBVC.swift
//  BatlingApp
//
//  Created by Ingouackaz on 2015-05-14.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class BatlingTBVC: UITabBarController , UITabBarControllerDelegate{

    var _cameraNC : UINavigationController = UINavigationController()
    var _photoTaken : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        for item in self.tabBar.items as! [UITabBarItem] {
            if let image = item.image {
                let titleDict: NSDictionary = [NSForegroundColorAttributeName:  UIColor.grayColor()]

                item.image = image.imageWithColor(UIColor.grayColor()).imageWithRenderingMode(.AlwaysOriginal)
                item.selectedImage = image.imageWithColor(UIColor.whiteColor()).imageWithRenderingMode(.AlwaysOriginal)
             //   item.title = ""
                
                item.setTitleTextAttributes(titleDict as [NSObject : AnyObject], forState: UIControlState.Normal)
            }
            
        }
        self.addCenterButtonWithImage(UIImage(named: "home_bat2")!, highlightImage: UIImage(named: "home_bat")!)

        // Do any additional setup after loading the view.
    }
    
    func addCenterButtonWithImage(image:UIImage, highlightImage:UIImage){
    
        var button : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    
        //button.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin |  UIViewAutoresizing.FlexibleLeftMargin |  UIViewAutoresizing.FlexibleTopMargin |  UIViewAutoresizing.FlexibleBottomMargin
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        button.setBackgroundImage(image, forState: UIControlState.Normal)
        
        var heightDifference = image.size.height - self.tabBar.frame.size.height
        if (heightDifference < 0){
        button.center = self.tabBar.center
        }
        else{
        
            var center = self.tabBar.center
            center.y = center.y - heightDifference / 2.0
            button.center = center
        }
        
        button.addTarget(self, action: "batAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
      //s  self.
    }
    
    func batAction(){
        self.selectedIndex = 2
    
    }

/*

    - (void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action
    {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0) {
    button.center = self.tabBar.center;
    } else {
    CGPoint center = self.tabBar.center;
    center.y = center.y - heightDifference/2.0;
    button.center = center;
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    self.centerButton = button;
    }
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        /*
        if(viewController.title == "CameraNC" && _photoTaken == false){
            var cameraNC = TGCameraNavigationController.newWithCameraDelegate(self)
            self.presentViewController(cameraNC, animated: true, completion: nil)
            
            return false
        }
        else{
            _photoTaken = false

            return true
        }*/
        return true

    }

    func cameraDidCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.selectedIndex = 0
    }
    

    
    func cameraDidSavePhotoWithError(error: NSError!) {
        self.selectedIndex = 0

    }

    func cameraDidSelectAlbumPhoto(image: UIImage!, texte txt: UINavigationController!) {
       /* var vc  = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoPickedTVC") as! PhotoPickedTVC
        
        vc._photo = image
        self.showViewController(vc, sender: nil)
        txt.pushViewController(vc, animated: true)*/
    }
    
    func cameraDidTakePhoto(image: UIImage!, texte txt: UINavigationController!) {
        /*
        var vc  = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoPickedTVC") as! PhotoPickedTVC
        
        vc._photo = image
        txt.pushViewController(vc, animated: true)*/
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
