//
//  SignUpTVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-31.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class SignUpTVC: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var passConfirmTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    var _userNameTxtField : UITextField?
    
    var _userNameFcb : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName:  UIColor(hexString: "46E0B5")]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        self.title = "Inscription"
        //  [textField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];

        navigationController?.navigationBar.tintColor = UIColor.whiteColor()

       // passConfirmTextField.text = "COKOKOKOK"
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
    
    @IBAction func signUpAction(sender: AnyObject) {
        
        var length  = count(userNameTextField.text)
        
        if(length < 3){
            self.displayAlertWithText("Merci de choisir un pseudo d'au minimum 3 caractères")

        }
        else{
            if(passTextField.text == passConfirmTextField.text){
                
                if (count(passTextField.text) < 6){
                    self.displayAlertWithText("Le mot de passe doit contenir au minimum 6 caractères")
                }
                else{
                    self.startSignUpRequest()
                    
                }
            }
            else{
                self.displayAlertWithText("Les deux mots de passe ne correspondent pas.")
            }
        }

    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func askPseudonyme(){
        var alert = UIAlertController(title: "Entrez un pseudo", message: "Entrez votre pseudo pour poster vos bats anonymement", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{(alert: UIAlertAction!) in
            self._userNameFcb = self._userNameTxtField!.text
            self.getFcbInformation()
        }))
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Jamel Debouze"
        }
        
        self.presentViewController(alert, animated: true) {
            
            self._userNameTxtField = alert.textFields!.first as? UITextField

        }
    }
    
    @IBAction func fcbConnectionAction(sender: AnyObject) {
        var permissions = [ "public_profile", "email", "user_friends" ]
        
        BatlingSingleton.sharedInstance.startLoading(self.view, text: "Connexion en cours")
        PFFacebookUtils.logInInBackgroundWithReadPermissions(permissions,  block: {  (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                if user.isNew {
                    println("User signed up and logged in through Facebook!")
                    FBSDKAppEvents.logEvent(batEventSignUpSuccessful)

                    self.askPseudonyme()
                   // self.getFcbInformation()
                    
                } else {
                    FBSDKAppEvents.logEvent(batEventSignInSuccessful)
                    
                    self.exitLoginMode()
                    println("User logged in through Facebook!")
                }
            } else {
                BatlingSingleton.sharedInstance.stopLoading()
                
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
                var email : String = userData["email"] as! String

                name = name.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                PFUser.currentUser()!.setValue(self._userNameFcb, forKey: "name")
                
              //   PFUser.currentUser()!.email =  email
                PFUser.currentUser()!.save()
                
                self.exitLoginMode()
                
                // NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                
            }
        })
        
    }
    
    
    func startSignUpRequest(){
        var newUser : PFUser = PFUser()
        
        newUser.username = userNameTextField.text
        newUser.setObject(userNameTextField.text, forKey: "name")
        newUser.email = mailTextField.text
        newUser.password = passTextField.text
        
        
        //PFObject(className: "Wish")
        BatlingSingleton.sharedInstance.startLoading(self.view, text: "Inscription en cours")
        newUser.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            //  self.loadIndicator.stopAnimating()
            
            BatlingSingleton.sharedInstance.stopLoading()

            if !(error != nil) {
                // Hooray! Let them use the app now.
                println("WHOOOOWOOO")
                FBSDKAppEvents.logEvent(batEventSignUpSuccessful)
                self.exitLoginMode()
            } else {
                var statusCode = error!.userInfo?["code"] as! Int
                if let errorString = error!.userInfo?["error"] as? NSString {
                    
                    if (statusCode == 200 || statusCode == 125){
                        
                        self.displayAlertWithText("Veuillez spécifier une adresse mail valide")
                    }
                    else if (statusCode == 202){
                        self.displayAlertWithText("Le nom d'utilisateur \(self.userNameTextField.text) est déjà pris. Veuillez en choisir un autre.")

                    }
                    else{
                        self.displayAlertWithText(errorString as String)
                        
                    }
                }
            }            
        }
    }
    

    
    func exitLoginMode(){
        

        BatlingSingleton.sharedInstance.stopLoading()

        var appD = UIApplication.sharedApplication().delegate as! AppDelegate
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        appD.window!.rootViewController = storyboard.instantiateInitialViewController() as! UINavigationController
        
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    func displayAlertWithText(text:String){
        let myAlert: UIAlertController = UIAlertController(title: "Erreur", message:text,
            preferredStyle: .Alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (textField.tag == 1){
            let newLength = count(textField.text.utf16) + count(string.utf16) - range.length
            return newLength <= 8
        }
        else{
            return true
        }
    }
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
