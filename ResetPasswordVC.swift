//
//  ResetPasswordVC.swift
//  Gladden
//
//  Created by Ingouackaz on 2015-05-27.
//  Copyright (c) 2015 DigitalStreet. All rights reserved.
//

import UIKit
import Parse
class ResetPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var resetAction: UIButton!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        self.startResetRquest()
        return true
    }
    
    @IBAction func resetAction(sender: AnyObject) {
        self.startResetRquest()
    }
    
    func startResetRquest(){
        
        PFUser.requestPasswordResetForEmailInBackground(emailTextField.text) { (succeed, error) -> Void in
            if (succeed == true ){
            self.displayAlertWithText("Un email de restauration de mot de passe vient d'être envoyé", title: "Merci")
            
            }
            else{
                println("error \(error)")
            self.displayAlertWithText("Aucun utilisateur ne possède cette adresse mail ", title: "Erreur")
                
            }
        }

    }
    
    
  
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        emailTextField.resignFirstResponder()
    }
    
    func displayAlertWithText(text:String, title:String){
        let myAlert: UIAlertController = UIAlertController(title: title, message:text,
            preferredStyle: .Alert)
        
        myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }))
        self.presentViewController(myAlert, animated: true, completion: nil)
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
