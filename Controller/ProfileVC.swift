//
//  ProfileVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-28.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController , UITableViewDataSource, UITableViewDelegate, BarCellDelegate{

    var _activityButton: UIButton!
    var _batsButton: UIButton!
    var _isInActivity : Bool = true
    
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
    
    func batsButtonPressed(cell: BarCell) {

       // cell.batsButton.selected = true
      //  cell.activityButton.selected = false
        self.tableView.reloadData()

        _isInActivity = false
    }

    func activityButtonPressed(cell: BarCell) {
        self.tableView.reloadData()
      //  cell.activityButton.selected = true
      //  cell.batsButton.selected = false

        _isInActivity = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 1){
            return 4
        }
        else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        if(indexPath.section == 0){
            var cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! BarCell
            cell.configureCell()
            cell.delegate = self
            cell.activityButton.selected = _isInActivity
            cell.batsButton.selected = !_isInActivity
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, cell.bounds.size.width)
            return cell
        }


        else {
            
            if (_isInActivity == true){
                return self.configureActivityCells(indexPath)
            }
            else {
                return configureBatsCells(indexPath)
            }
        }
        
    }
    
    func shareAction(){
        
        
        let myView = NSBundle.mainBundle().loadNibNamed("ShareView", owner: nil, options: nil)[0] as! UIView
        
        
        var popup : KLCPopup = KLCPopup(contentView: myView)
        popup.show()
        
    }
    
    
    func configureBatsCells(indexPath: NSIndexPath) -> UITableViewCell{
        if ((indexPath.row % 2) != 0){
            var cell = tableView.dequeueReusableCellWithIdentifier("CellText", forIndexPath: indexPath) as! FeedTextCell
            cell.shareButton.addTarget(self, action: "shareAction", forControlEvents: UIControlEvents.TouchUpInside)

            cell.batLabel.text = "okdpoe"
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCellWithIdentifier("CellImage", forIndexPath: indexPath) as! FeedImageCell
            cell.shareButton.addTarget(self, action: "shareAction", forControlEvents: UIControlEvents.TouchUpInside)

            cell.configureCell()
            return cell
        }
    }
    
    func configureActivityCells(indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as! ActivityCell
        
        return cell
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
