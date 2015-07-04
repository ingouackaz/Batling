//
//  MenuVc.swift
//  FoodChainS
//
//  Created by Roger Ingouacka on 26/10/2014.
//  Copyright (c) 2014 Roger Ingouacka. All rights reserved.
//

import UIKit

class MenuVc: AMSlideMenuLeftTableViewController {

    var _transitionsNavigationController : UINavigationController?
//    @property (nonatomic, strong) UINavigationController *transitionsNavigationController;

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.navigationController?.navigationBar.barTintColor =  UIColor(hexString: "#e67e22")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //self.navigationController?.navigationBar.titleTextAttributes = titleDict

     //   self._transitionsNavigationController = self.slidingViewController.topViewController as UINavigationController

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
//    -(NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath;

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 2){
            PFUser.logOutInBackgroundWithBlock { (error) -> Void in
                PFQuery.clearAllCachedResults()
                FBSDKAppEvents.logEvent(batEventLogoutPressed)

                self.exitLoginMode()

            }
        }
    }
    
    
    func exitLoginMode(){
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var loginNC = storyboard.instantiateViewControllerWithIdentifier("LoginNC") as! UINavigationController
        
        
        var appD = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appD.window!.rootViewController = storyboard.instantiateViewControllerWithIdentifier("LoginNC") as! UINavigationController
        
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

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
