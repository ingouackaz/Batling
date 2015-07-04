//
//  HomeVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-28.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, AMSlideMenuDelegate, FeedTextCellDelegate, FeedImageCellDelegate {

    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var recentButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var _feed : Array<PFObject> = []

    
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
            self.startFeedRequest()
        }
        
        
    }
    @IBAction func showSideMenu(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("showSideMenu", object: nil)
        
    }
    
    @IBAction func popularButtonPressed(sender: AnyObject) {
        
        popularButton.selected = true
        recentButton.selected = false
        FBSDKAppEvents.logEvent(batEventPopularCategoryPressed)

    }

    @IBAction func recentButtonPressed(sender: AnyObject) {
        recentButton.selected = true
        popularButton.selected = false
        FBSDKAppEvents.logEvent(batEventRecentsCategoryPressed)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _feed.count
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        var joke = BatJoke(object: _feed[indexPath.row])

        
        if (joke.type == kPBatJokeTypePunchline){
            var cell = tableView.dequeueReusableCellWithIdentifier("CellText", forIndexPath: indexPath) as! FeedTextCell
            cell.shareButton.addTarget(self, action: "shareAction:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.shareButton.tag = indexPath.row
            cell.delegate = self
            cell.configureCellWith(joke)
            return cell
        }
        else{
            var cell = tableView.dequeueReusableCellWithIdentifier("CellImage", forIndexPath: indexPath) as! FeedImageCell
            cell.shareButton.addTarget(self, action: "shareAction:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.shareButton.tag = indexPath.row

            cell.delegate = self
            cell.configureCellWith(joke)
            return cell
            
        }                
    }
    
    func shareAction(button:UIButton){
        var joke = BatJoke(object: _feed[button.tag])
        
        
        if (joke.type == kPBatJokeTypeMeme){
            
            var activityItems: [AnyObject]?
            
             var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: button.tag, inSection: 0)) as! FeedImageCell
            if (cell.pictureImageView?.image != nil) {
                let image = cell.pictureImageView!.image

                activityItems = [image!]
                let activityController = UIActivityViewController(activityItems:
                    activityItems!, applicationActivities: nil)
                activityController.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]

                self.presentViewController(activityController, animated: true,
                    completion: nil)
            }

        }
        else{
            var cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: button.tag, inSection: 0)) as! FeedTextCell
            var activityItems: [AnyObject]?

            let firstActivityItem = cell.batLabel.text!
            var activityVC = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [
                UIActivityTypePostToWeibo,
                UIActivityTypePrint,
                UIActivityTypeCopyToPasteboard,
                UIActivityTypeAssignToContact,
                UIActivityTypeSaveToCameraRoll,
                UIActivityTypeAddToReadingList,
                UIActivityTypePostToFlickr,
                UIActivityTypePostToVimeo,
                UIActivityTypePostToTencentWeibo,
                UIActivityTypeAirDrop
            ]
            
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]

            activityVC.completionWithItemsHandler = {(activityType: String!, completed: Bool, arrayOptions: [AnyObject]!, error: NSError!) in
                println(activityType)
            }
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
        

        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
    func startFeedRequest(){
        
        
        var query : PFQuery = PFQuery(className: kPBatJokeClassKey)
        
        query.findObjectsInBackgroundWithBlock ({(objects:[AnyObject]?, error: NSError?) in
            if(error == nil){
                self._feed.removeAll(keepCapacity: false)
                for object in objects! {
                    println(" object \(object)")
                    // verifier aucune activité de type report
                    self._feed.append(object as! PFObject)
                }
                self._feed = self._feed.reverse()
                self.tableView.reloadData()
            }
            else{
                
                BatlingSingleton.sharedInstance.displayAlertWithText(self, text: "Impossible de récupérer le fil d'actualité, veuillez vérifier votre connexion à internet puis réessayer.")
                
            }
        })
    }
    
    func startReportBatRequest(joke: BatJoke,indexPath:NSIndexPath){
        
        var reportActivity = PFObject(className:kPBatActivityClassKey)
        
        reportActivity.setObject(kPBatActivityTypeReport, forKey: kPBatActivityTypeKey)
        reportActivity.setObject(PFUser.currentUser()!, forKey: kPBatActivityFromUserKey)
        reportActivity.setObject(joke.object!.objectForKey(kPBatJokeUserKey)!, forKey: kPBatActivityToUserKey)
        reportActivity.setObject(joke.object!, forKey: kPBatActivityBatJokeClassKey)
        
        var reportACL :  PFACL = PFACL(user: PFUser.currentUser()!)
        
        reportACL.setPublicReadAccess(true)
        reportACL.setWriteAccess(true, forUser: joke.object?.objectForKey(kPBatJokeUserKey) as! PFUser)
        reportActivity.ACL = reportACL
        
        
        reportActivity.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if (succeeded == true){
                println("indexPath \(indexPath)")
                self._feed.removeAtIndex(indexPath.row)
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.endUpdates()
            }
        }
    }

    func didTapPhotoBat(joke: BatJoke, button: UIButton, cell: FeedImageCell, type: PhotoType) {
        
        if(type == PhotoType.Like){
            
            PAPCache.sharedCache().setPhotoIsLikedByCurrentUser(joke.object, liked: true)
            
            PAPUtility.likePhotoInBackground(joke.object, type: "meme" ,block: { (succeed, error) -> Void in
                cell.shouldEnableLikeButton(true)
                cell.setLikeAndDislikeStatus(true, disliked: false)
                
                if(!succeed){
                    cell.unlikeButton.hidden = false
                    cell.likeButton.selected = false
                }
            })
        }
        else{
            PAPCache.sharedCache().setPhotoIsDislikedByCurrentUser(joke.object, liked: true)
            
            PAPUtility.dislikePhotoInBackground(joke.object, type: "meme", block: { (succeed, error) -> Void in
                cell.shouldEnableDislikeButton(true)
                cell.setLikeAndDislikeStatus(false, disliked: true)
                
                if(!succeed){
                    cell.unlikeButton.hidden = false
                    cell.unlikeButton.selected = false
                }
            })
        }
    }
    
    
    func didReportBat(joke: BatJoke, cell: UITableViewCell) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        
        var indexPath = self.tableView.indexPathForCell(cell)
        let cancelAction = UIAlertAction(title: "Annuler", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)

        
        
        let infoAction = UIAlertAction(title: "Partage d'infos personnelles", style: .Default) { (action) in
            // ...
            self.startReportBatRequest(joke,indexPath: indexPath!)
        }
        alertController.addAction(infoAction)
        
        let masquerAction = UIAlertAction(title: "Incitation à la haine", style: .Default) { (action) in
            // ...
            self.startReportBatRequest(joke,indexPath: indexPath!)
        }
        alertController.addAction(masquerAction)
        

        
        let blockAction = UIAlertAction(title: "Publicité", style: .Default) { (action) in
            // ...
            self.startReportBatRequest(joke,indexPath: indexPath!)

        }
        alertController.addAction(blockAction)
        
        let OKAction = UIAlertAction(title: "Signaler cette publication", style: .Default) { (action) in
            // ...
            self.startReportBatRequest(joke,indexPath: indexPath!)

        }
        alertController.addAction(OKAction)

        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }


    
    
    func didTapTextBat(joke:BatJoke, button: UIButton, cell: FeedTextCell, type: PhotoType) {
        
        if(type == PhotoType.Like){
        
            PAPCache.sharedCache().setPhotoIsLikedByCurrentUser(joke.object, liked: true)
                PAPUtility.likePhotoInBackground(joke.object, type: "punchline",block: { (succeed, error) -> Void in
                    cell.shouldEnableLikeButton(true)
                    cell.setLikeAndDislikeStatus(true, disliked: false)
                    
                    if(!succeed){
                        cell.unlikeButton.hidden = false
                        cell.likeButton.selected = false
                    }
                })
        }
        else{
            PAPCache.sharedCache().setPhotoIsDislikedByCurrentUser(joke.object, liked: true)
                
                PAPUtility.dislikePhotoInBackground(joke.object, type: "punchline", block: { (succeed, error) -> Void in
                    cell.shouldEnableDislikeButton(true)
                    cell.setLikeAndDislikeStatus(false, disliked: true)
                    
                    if(!succeed){
                        cell.unlikeButton.hidden = false
                        cell.unlikeButton.selected = false
                    }
                })
        }
    }

}
