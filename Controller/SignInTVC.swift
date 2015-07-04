//
//  SignInTVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-31.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class SignInTVC: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    var _userNameFcb : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName:  UIColor(hexString: "46E0B5")]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        self.title = "Connexion"
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        self.tableView.delaysContentTouches = false
        
        
        for(index, obj) in enumerate(self.tableView.subviews){
            
            if ((obj as! UIView).isKindOfClass(UIScrollView)){
                (obj as! UIScrollView).delaysContentTouches = false
                break
            }
        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func fcbConnectionAction(sender: AnyObject) {
        var permissions = [ "public_profile", "email", "user_friends" ]
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions,  block: {  (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    PFUser.currentUser()!.username = self._userNameFcb
                    
                        self.askPseudonyme()
                } else {
                    println("User logged in through Facebook!")
                    self.exitLoginMode()
                }
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        })
    }
    
    func getFcbInformation(){
        
        var request : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        request.startWithCompletionHandler({ (connection, result, error) -> Void in
            if (error == nil) {
                var userData : NSDictionary  = result as! NSDictionary
                println("User FCB data \(result)")
                
                var name : String = userData["name"] as! String
                name = name.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                PFUser.currentUser()!.setValue(self._userNameFcb, forKey: "name")
                PFUser.currentUser()!.save()
                
                self.exitLoginMode()

                // NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                
            }
        })
        
    }

    func askPseudonyme(){
        var alert = UIAlertController(title: "Entrez un pseudo", message: "Entrez votre pseudo pour poster vos bats anonymement", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Jamel Debouze"
        }
        
        self.presentViewController(alert, animated: true) {
            
            let textField = alert.textFields!.first as! UITextField
            self._userNameFcb = textField.text
            self.getFcbInformation()
        }
    }
    
    func exitLoginMode(){
        
        
        var appD = UIApplication.sharedApplication().delegate as! AppDelegate
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        appD.window!.rootViewController = storyboard.instantiateInitialViewController() as! UINavigationController
        
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
        
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    @IBAction func signInAction(sender: AnyObject) {
        self.startLoginRequest()
    }
    
    
    
    func startLoginRequest(){
        userNameTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
        
        BatlingSingleton.sharedInstance.startLoading(self.view, text: "Connexion en cours")
        PFUser.logInWithUsernameInBackground(userNameTextField.text, password: passTextField.text, block: {
            (user, error) in
            NSLog("result \(user) && \(error)")
            BatlingSingleton.sharedInstance.stopLoading()
            if (user != nil){
                PFUser.currentUser()!.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                    self.exitLoginMode()
                })
                
            }
            else{
                let myAlert: UIAlertController = UIAlertController(title: "Erreur", message: "Le pseudo ou le mot de passe est incorrect", preferredStyle: .Alert)
                myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(myAlert, animated: true, completion: nil)
                
            }
        } )
        
    }

    func displayAlertWithText(text:String){
        let myAlert: UIAlertController = UIAlertController(title: "Erreur", message:text,
            preferredStyle: .Alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

}
