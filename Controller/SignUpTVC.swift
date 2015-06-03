//
//  SignUpTVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-31.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class SignUpTVC: UITableViewController {

    @IBOutlet weak var passConfirmTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleDict: NSDictionary = [NSForegroundColorAttributeName:  UIColor(hexString: "46E0B5")]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        self.title = "Inscription"
        //  [textField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];

        navigationController?.navigationBar.tintColor = UIColor.whiteColor()

       // passConfirmTextField.text = "COKOKOKOK"
        self.tableView.delaysContentTouches = false
        
        
        for(index, obj) in enumerate(self.tableView.subviews){
        
            if ((obj as! UIView).isKindOfClass(UIScrollView)){
                (obj as! UIScrollView).delaysContentTouches = false
                break
            }
        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

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
