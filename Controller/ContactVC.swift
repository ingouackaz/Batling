//
//  ContactVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-06-01.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class ContactVC: UIViewController {

    @IBOutlet weak var sendButton: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.image = UIImage(named: "envoyer")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName:  UIColor(hexString: "46E0B5")]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showSideMenu(sender: AnyObject) {
        self.textView.resignFirstResponder()
        NSNotificationCenter.defaultCenter().postNotificationName("showSideMenu", object: nil)

    }
    @IBAction func leaveAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func sendAction(sender: AnyObject) {
        self.textView.resignFirstResponder()
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
