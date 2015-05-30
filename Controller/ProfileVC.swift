//
//  ProfileVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-28.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController , UITableViewDataSource, UITableViewDelegate{

    var _activityButton: UIButton!
    var _batsButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //activityButton.selected = true
        //batsButton.selected = false
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName:  UIColor(hexString: "46E0B5")]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func batsButtonPressed(sender: AnyObject) {
        _activityButton.selected = false
        _batsButton.selected = true
    }
    
    @IBAction func activityButtonPressed(sender: AnyObject) {
        _activityButton.selected = true
        _batsButton.selected = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        if(indexPath.section == 0){
            var cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        
        }
        else if (indexPath.section == 1){
            var cell = tableView.dequeueReusableCellWithIdentifier("BarCell", forIndexPath: indexPath) as! BarCell
            
            var origin = cell.activityButton!.frame.origin
            
            origin.x = 0
            cell.activityButton!.frame = CGRect(origin:origin, size: CGSize(width: 400, height: 400))
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.preservesSuperviewLayoutMargins = false;
            return cell
        }
        else {
            if ((indexPath.row % 2) != 0){
                var cell = tableView.dequeueReusableCellWithIdentifier("CellText", forIndexPath: indexPath) as! FeedTextCell
                
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
                
                
                return cell
                
            }
        }
        
        

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
