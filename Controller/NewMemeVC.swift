//
//  NewMemeVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-30.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class NewMemeVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var upTextView: SZTextView!
    @IBOutlet weak var downTextView: SZTextView!
    
    @IBOutlet weak var imageView: UIImageView!
    var kbHeight: CGFloat!
    var _kbIsUp : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        upTextView.resignFirstResponder()
        downTextView.resignFirstResponder()

        
    }

    
    func keyboardWillShow(notification: NSNotification) {
        if (_kbIsUp == false){
            _kbIsUp = true
            if let userInfo = notification.userInfo {
                if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                    kbHeight = keyboardSize.height / 2
                    self.animateTextField(true)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if (_kbIsUp == true){
            _kbIsUp = false
            self.animateTextField(false)
        }

    }
    
    func animateTextField(up: Bool) {
        var movement = (up ? -kbHeight : kbHeight)
        
        UIView.animateWithDuration(0.6, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        upTextView.resignFirstResponder()
        downTextView.resignFirstResponder()

    }
    
    
    @IBAction func galleryAction(sender: UIButton) {
        self.openGallary(sender)
    }
    
    
    @IBAction func openGallery(sender: UIButton) {
        self.openGallary(sender)

    }

    func openCamera(sender: UIButton)
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            var picker:UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            self .presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            openGallary(sender)
        }
    }
    
    @IBAction func photoAction(sender: UIButton) {
        self.openCamera(sender)
    }

    @IBAction func googleAction(sender: UIButton) {
        self.openSearch(sender)

    }
    func openSearch(sender: UIButton){
        
        var storyboard = UIStoryboard(name: "Image&Mot", bundle: nil)
        
        /*
        var vc : SWRevealViewController =  storyboard.instantiateViewControllerWithIdentifier("searchVC") as!  SWRevealViewController
        
        
        var xpopover:UIPopoverController = UIPopoverController(contentViewController: vc)
        
        xpopover=UIPopoverController(contentViewController: vc)
        xpopover.presentPopoverFromRect(sender.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)*/
    }
    
    
    func openGallary(sender: UIButton)
    {
        var picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        
        self.presentViewController(picker, animated: true, completion: nil)
        

        let friends = [
            "firstName": "Susan",
            "lastName": "Olson",
            "profilePicture": "susan_profile.png"
        ]
        
        var imgName : String = friends["profilePicture"]!
        
        let profileImageName  =  UIImage(named: imgName)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        // picker.dismissViewControllerAnimated(true, completion: nil)
        
        var img = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        img = img!.resizedImageToFitInSize(CGSize(width: 500, height: 500), scaleIfSmaller: true)
        
        self.imageView.image = img
        
         picker.dismissViewControllerAnimated(true, completion: nil)
        // img = img!.squareImageFromImage(img, scaledToSize: 600)
        
        /*
        var pickVc : CropPictureVC = self.storyboard?.instantiateViewControllerWithIdentifier("CropPictureVC") as! CropPictureVC
        
        pickVc._selectedImage = img
        picker.pushViewController(pickVc, animated: true)
        */
        
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
