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
    
    var _orangeVC : UIViewController?
    var _purpleVC : UIViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        publishButton.image = UIImage(named: "Publier")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)


        let titleDict: NSDictionary = [NSForegroundColorAttributeName:  UIColor(hexString: "46E0B5")]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        punchlineButton.selected = false
        memeButton.selected = true


        _orangeVC = self.storyboard?.instantiateViewControllerWithIdentifier("orangeVC") as? UIViewController
        _purpleVC = self.storyboard?.instantiateViewControllerWithIdentifier("purpleVC") as? UIViewController
        
        activeViewController = _orangeVC


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
        
        punchlineButton.selected = false
        memeButton.selected = true
        
       // self = NSBundle.mainBundle().loadNibNamed("ViewDetailMenu", owner: 0, options: nil)[0] as? UIView

        
        activeViewController = _orangeVC

        //self.tableView.reloadData()
    }
    
    
    // publishAction
    
    @IBAction func publishAction(sender: AnyObject) {

       self.performSegueWithIdentifier("backToTBVC", sender: nil)
       // self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func memeButtonPressed(sender: AnyObject) {
        punchlineButton.selected = true
        memeButton.selected = false
        //self.tableView.reloadData()
        activeViewController = _purpleVC

    }


    @IBAction func leaveAction(sender: AnyObject) {
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
