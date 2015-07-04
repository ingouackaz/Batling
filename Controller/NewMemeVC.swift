//
//  NewMemeVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-30.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class NewMemeVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate, DZNPhotoPickerControllerDelegate {

    @IBOutlet weak var upTextView: SZTextView!
    @IBOutlet weak var addTextButton: UIButton!


    @IBOutlet weak var memeView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var kbHeight: CGFloat!
    var _kbIsUp : Bool = false
    var _photoTaken : Bool = false
    
    @IBOutlet weak var uptextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var publishLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upTextView.sizeToFit()
        DZNPhotoPickerController.registerFreeService(DZNPhotoPickerControllerServices.ServiceGoogleImages, consumerKey: "AIzaSyBiRs6vQmTVseUnMqUtJwpaJX-m5o9Djr0", consumerSecret: "018335320449571565407:tg2a0fkobws")
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.addTextButton.enabled = false
        self.upTextView.hidden = true
        self.addTextButton.setImage(UIImage(named: "AddImage_textinactif"), forState: UIControlState.Normal)
        
        upTextView.layoutManager.usedRectForTextContainer(upTextView.textContainer)
        upTextView.sizeToFit()
        upTextView.layoutManager.allowsNonContiguousLayout = false
        upTextView.layoutIfNeeded()
        // AddImage_textinactif
        // textView.textContainer.maximumNumberOfLines = 10;
        publishLabel.hidden = _photoTaken
        self.upTextView.textContainer.maximumNumberOfLines = 3
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "croppedImage:", name:"croppedImage", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "searchImageSelected:", name:"searchImageSelected", object: nil)


        
    }
    
    

    @IBAction func addTextAction(sender: AnyObject) {
        self.upTextView.hidden = false
        self.upTextView.becomeFirstResponder()
        FBSDKAppEvents.logEvent(batEventAddTextToImagePressed)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (_photoTaken == true){
            self.addTextButton.enabled = true
            self.addTextButton.setImage(UIImage(named: "AddImage_textactif"), forState: UIControlState.Normal)
        }
        
        publishLabel.hidden = _photoTaken
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        upTextView.resignFirstResponder()
        
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

        if (upTextView.text == ""){
            upTextView.hidden = true
        }
    }
    
    
    @IBAction func galleryAction(sender: UIButton) {
        self.openGallary(sender)
        FBSDKAppEvents.logEvent(batEventAlbumAddPhotoPressed)

    }
    
    
    @IBAction func openGallery(sender: UIButton) {
        self.openGallary(sender)
        FBSDKAppEvents.logEvent(batEventAlbumAddPhotoPressed)

    }

    func openCamera(sender: UIButton)
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            var picker:UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            //picker.cropMode = DZNPhotoEditorViewControllerCropMode.Square
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
        FBSDKAppEvents.logEvent(batEventCameraAddImagePressed)

    }

    @IBAction func googleAction(sender: UIButton) {
        FBSDKAppEvents.logEvent(batEventGoogleAddImagePressed)
        self.openSearch(sender)


    }
    func openSearch(sender: UIButton){
        
        
        
        var picker : DZNPhotoPickerController = DZNPhotoPickerController()
        picker.supportedServices = DZNPhotoPickerControllerServices.ServiceGoogleImages
        picker.delegate = self
        //picker.allowsEditing = true
        picker.cropMode = DZNPhotoEditorViewControllerCropMode.Square
        picker.enablePhotoDownload = true
         let titleDict: NSDictionary = [NSForegroundColorAttributeName:  UIColor(hexString: "46E0B5")]
        // self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        
        picker.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    

    
    func photoPickerController(picker: DZNPhotoPickerController!, didFailedPickingPhotoWithError error: NSError!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func photoPickerController(picker: DZNPhotoPickerController!, didFinishPickingPhotoWithInfo userInfo: [NSObject : AnyObject]!) {
        
        println("user info  \(userInfo)")
        
        var img = userInfo[UIImagePickerControllerOriginalImage] as? UIImage
        
       // img = img!.resizedImageToFitInSize(CGSize(width: 500, height: 500), scaleIfSmaller: true)
        
        self.imageView.image = img
        _photoTaken = true
        publishLabel.hidden = _photoTaken
               //picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func photoPickerControllerDidCancel(picker: DZNPhotoPickerController!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func croppedImage(notification: NSNotification){
    
        
        let defaults = NSUserDefaults.standardUserDefaults()

        
        var img =  (notification.object as! UIImage)
        self.imageView.image = img
        _photoTaken = true
        publishLabel.hidden = _photoTaken
    }
    
    func searchImageSelected(notification: NSNotification){
     
        FBSDKAppEvents.logEvent(batEventImageAddedFromGoogle)

        var url : NSURL =  (notification.object as! NSURL)
        
        
        var pickVc : CropPictureVC = self.storyboard?.instantiateViewControllerWithIdentifier("CropPictureVC") as! CropPictureVC
        
        pickVc._seletedImageUrl = url
        self.navigationController!.pushViewController(pickVc, animated: true)
    }
    
    
    
    func openGallary(sender: UIButton)
    {
        var picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
       // picker.cropMode = DZNPhotoEditorViewControllerCropMode.Square
        
        
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        // picker.dismissViewControllerAnimated(true, completion: nil)
        
        println("user info  \(info)")

        var img = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        img = img!.resizedImageToFitInSize(CGSize(width: 500, height: 500), scaleIfSmaller: true)
        
        var pickVc : CropPictureVC = self.storyboard?.instantiateViewControllerWithIdentifier("CropPictureVC") as! CropPictureVC
        
        pickVc._selectedImage = img
        picker.pushViewController(pickVc, animated: true)


        
    }


}
