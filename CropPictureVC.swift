//
//  CropPictureVC.swift
//  Leapps
//
//  Created by Ingouackaz on 2015-05-26.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

@objc class CropPictureVC: UIViewController {

    
    @IBOutlet weak var validButton: UIButton!
    var _selectedImage : UIImage?
    var _crop : HIPImageCropperView = HIPImageCropperView()
    var _seletedImageUrl : NSURL?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var hiddenView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

       _crop = HIPImageCropperView(frame:self.view.bounds, cropAreaSize:CGSize(width: self.hiddenView.frame.width, height: self.hiddenView.frame.width), position: HIPImageCropperViewPosition.Center)
        
        println("size \(self.hiddenView.layer.frame)")
        self.view.insertSubview(_crop, belowSubview: self.view)
        
        var doneButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.frame = CGRect(x:self.view.frame.width -
            100 , y:self.view.frame.height - 30, width: 70, height: 30)
        doneButton.setTitle("Terminer", forState: UIControlState.Normal)
        doneButton.titleLabel!.text = "Terminer"
        doneButton.addTarget(self, action: "doneAction", forControlEvents:UIControlEvents.TouchUpInside)
        

        var cancelButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton

        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelButton.frame = CGRect(x:30 , y:self.view.frame.height - 30, width: 70, height: 30)
        cancelButton.setTitle("Annuler", forState: UIControlState.Normal)
        cancelButton.titleLabel!.text = "Annuler"
        cancelButton.addTarget(self, action: "cancelAction", forControlEvents:UIControlEvents.TouchUpInside)
        
        
        self.view.addSubview(doneButton)

        self.view.addSubview(cancelButton)

        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let name = defaults.URLForKey("sourceUrl")
        {
            println("name \(name)")
            defaults.removeObjectForKey("sourceUrl")

            self.downloadImage(name)

        }
        else{
            _crop.originalImage = _selectedImage!

        }

    }
    
    func downloadImage(url:NSURL){
        println("Started downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                println("Finished downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
                //
                self._crop.originalImage = UIImage(data: data!)
            }
        }
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: NSData(data: data))
            }.resume()
    }

    func doneAction(){
        
        var img = _crop.processedImage()
        
        NSNotificationCenter.defaultCenter().postNotificationName("croppedImage", object: img)

        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func cancelAction(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func validAction(sender: AnyObject) {
        
    }


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
