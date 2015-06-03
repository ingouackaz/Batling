//
//  HomeVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-28.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, AMSlideMenuDelegate {

    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var recentButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor =  UIColor(hexString: "061242")
        
       
        let titleDict: NSDictionary = [NSForegroundColorAttributeName:  UIColor(hexString: "46E0B5")]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        popularButton.selected = true
        recentButton.selected = !popularButton.selected
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didChangePreferredContentSize", name: UIContentSizeCategoryDidChangeNotification, object: nil)

        
       // self.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, self.tableView.numberOfSections())), withRowAnimation: .None)

        
        //self.tableView.registerClass(FeedTextCell.self, forCellReuseIdentifier: "CellText") // uncomment this line to load table view cells programmatically

        // Self-sizing table view cells in iOS 8 are enabled when the estimatedRowHeight property of the table view is set to a non-zero value.
        // Setting the estimated row height prevents the table view from calling tableView:heightForRowAtIndexPath: for every row in the table on first load;
        // it will only be called as cells are about to scroll onscreen. This is a major performance optimization.
        // Do any additional setup after loading the view.
    }
    
    func didChangePreferredContentSize(notification:NSNotification){
        
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
        self.tableView.reloadData()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.setNeedsLayout()
        tableView.layoutIfNeeded()
//        self.tableView.reloadData()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (BatlingSingleton.sharedInstance._seletectedMenuIndex == 0){
            BatlingSingleton.sharedInstance._seletectedMenuIndex = -1
            var BatVc = self.storyboard?.instantiateViewControllerWithIdentifier("helpNC") as! UINavigationController
            
            self.presentViewController(BatVc, animated: true, completion: nil)
        }
        else if (BatlingSingleton.sharedInstance._seletectedMenuIndex == 1){
            
            BatlingSingleton.sharedInstance._seletectedMenuIndex = -1
            var BatVc = self.storyboard?.instantiateViewControllerWithIdentifier("contactNC") as! UINavigationController
            
            self.presentViewController(BatVc, animated: true, completion: nil)
        }
        else{
        
        }
        
        
    }
    @IBAction func showSideMenu(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("showSideMenu", object: nil)
        
    }
    
    @IBAction func popularButtonPressed(sender: AnyObject) {
        
        popularButton.selected = true
        recentButton.selected = false
    }

    @IBAction func recentButtonPressed(sender: AnyObject) {
        recentButton.selected = true
        popularButton.selected = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    

        
        
        if ((indexPath.row % 2) != 0){
        var cell = tableView.dequeueReusableCellWithIdentifier("CellText", forIndexPath: indexPath) as! FeedTextCell
        
           cell.shareButton.addTarget(self, action: "shareAction", forControlEvents: UIControlEvents.TouchUpInside)

        cell.batLabel.text = "okdpoekopdkskposdkpozkdpozekdpozeskdoizsjdozdozsedoizesdoizejdoizjsediojszeoidjzseoidjzseoidjzseoijdzsoijdzsoijdozsiejdposzedjposedp0d0pwù9dùpkswopsùkawùposkùaiwdùaujspoùwjasùjaskpoùakspùoakspoùka"
        return cell
        }
        else {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellImage", forIndexPath: indexPath) as! FeedImageCell
        
        var origin = cell.pictureImageView!.frame.origin
        
        origin.x = 0
        cell.pictureImageView!.frame = CGRect(origin:origin, size: CGSize(width: 400, height: 400))
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = false;
        
        cell.shareButton.addTarget(self, action: "shareAction", forControlEvents: UIControlEvents.TouchUpInside)

        return cell

        }

                
    }
    
    func shareAction(){
        
        
        let myView = NSBundle.mainBundle().loadNibNamed("ShareView", owner: nil, options: nil)[0] as! UIView


        var popup : KLCPopup = KLCPopup(contentView: myView)
        popup.show()
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
