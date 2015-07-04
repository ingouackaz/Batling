//
//  NewBatVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-30.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class NewBatVC: UIViewController {

    //@IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var memeButton: UIButton!
    @IBOutlet weak var punchlineButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var publishButton: UIBarButtonItem!
    
    var _orangeVC : NewPunchlineVC?
    var _purpleVC : NewMemeVC?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        /*
        [DZNPhotoPickerController registerService:DZNPhotoPickerControllerServiceFlickr
            consumerKey:YOUR_Flickr_KEY
            consumerSecret:YOUR_Flickr_SECRET
            subscription:DZNPhotoPickerControllerSubscriptionFree];*/
        
        publishButton.image = UIImage(named: "Publier")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)


        let titleDict: NSDictionary = [NSForegroundColorAttributeName:  UIColor(hexString: "46E0B5")]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        punchlineButton.selected = false
        memeButton.selected = true


        _orangeVC = self.storyboard?.instantiateViewControllerWithIdentifier("orangeVC") as? NewPunchlineVC
        _purpleVC = self.storyboard?.instantiateViewControllerWithIdentifier("purpleVC") as? NewMemeVC
        
        activeViewController = _purpleVC


    }

    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func punchlineButtonPressed(sender: AnyObject) {
        
        punchlineButton.selected = true
        memeButton.selected = false
        
        
        activeViewController = _orangeVC
        FBSDKAppEvents.logEvent(batEventPunchlineCategorySelected)

        //self.tableView.reloadData()
    }
    
    @IBAction func memeButtonPressed(sender: AnyObject) {
        punchlineButton.selected = false
        memeButton.selected = true
        //self.tableView.reloadData()
        activeViewController = _purpleVC
        FBSDKAppEvents.logEvent(batEventMemeCategorySelected)
        
        
    }
    
    
    // publishAction
    
    @IBAction func publishAction(sender: AnyObject) {

        // inversé
        if(memeButton.selected == true){
            self.publishMeme()
            FBSDKAppEvents.logEvent(batEventImageBatJokePublished)

            
        }
        else{
            self.publishPunchline()
            FBSDKAppEvents.logEvent(batEventPunchlineBatJokePublished)
        }
        
    }
    
    func publishPunchline(){
        
        
        if (_orangeVC!.punchlineTextView.text != ""){
            _orangeVC!.punchlineTextView.resignFirstResponder()
            
            var batjoke : PFObject = PFObject(className: kPBatJokeClassKey)
            batjoke.setObject(PFUser.currentUser()!, forKey: kPBatJokeUserKey)
            batjoke.setObject(kPBatJokeTypePunchline, forKey: kPBatJokeTypeKey)
            batjoke.setObject(_orangeVC!.punchlineTextView.text, forKey: kPBatJokeTypePunchlineTextKey)
            BatlingSingleton.sharedInstance.startLoading(self.view, text: "")
            batjoke.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                BatlingSingleton.sharedInstance.stopLoading()
                
                if(succeeded == true){
                    println("photo uploaded")
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                else{
                    var errorString =  (error!.userInfo?["error"] as? NSString) as! String
                    BatlingSingleton.sharedInstance.displayAlertWithText(self, text: errorString)
                }
            }
        }
        else{
            BatlingSingleton.sharedInstance.displayAlertWithText(self, text: "Veuillez entrez du texte")

        }
        
    }
    
    func publishMeme(){
        
        
        if (_purpleVC!._photoTaken == true){
            
            if(_purpleVC!.upTextView.text == ""){
            _purpleVC!.upTextView.hidden = true
            }
            _purpleVC!.upTextView.resignFirstResponder()

            var resizedImage = UIImage(view: _purpleVC!.memeView)
            var imageData =  UIImageJPEGRepresentation(resizedImage, 0.7)
            
            
            var pictureFile = PFFile(data:imageData)

            
            
            var batjoke : PFObject = PFObject(className: kPBatJokeClassKey)
            batjoke.setObject(PFUser.currentUser()!, forKey: kPBatJokeUserKey)
            batjoke.setObject(kPBatJokeTypeMeme, forKey: kPBatJokeTypeKey)
            batjoke.setObject(pictureFile, forKey: kPBatJokeTypeMemeImageKey)
            BatlingSingleton.sharedInstance.startLoading(self.view, text: "")
            batjoke.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                BatlingSingleton.sharedInstance.stopLoading()
                
                if(succeeded == true){
                    println("photo uploaded")
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                else{
                    var errorString =  (error!.userInfo?["error"] as? NSString) as! String
                    BatlingSingleton.sharedInstance.displayAlertWithText(self, text: errorString)
                }
            }
        }
        else{
            BatlingSingleton.sharedInstance.displayAlertWithText(self, text: "Veuillez selectionner une photos")
        }
        
        
    }
    



    @IBAction func leaveAction(sender: AnyObject) {
        FBSDKAppEvents.logEvent(batEventBatJokeCanceled)

        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inActiveVC = inactiveViewController {
            // call before removing child view controller's view from hierarchy
            inActiveVC.willMoveToParentViewController(nil)
            
            inActiveVC.view.removeFromSuperview()
            
            // call after removing child view controller's view from hierarchy
            inActiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            // call before adding child view controller's view as subview
            addChildViewController(activeVC)
            
            activeVC.view.frame = containerView.bounds
            containerView.addSubview(activeVC.view)
            
            // call before adding child view controller's view as subview
            activeVC.didMoveToParentViewController(self)
        }
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
