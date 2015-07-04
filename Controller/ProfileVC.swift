//
//  ProfileVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-28.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController , UITableViewDataSource, UITableViewDelegate, BarCellDelegate, GlobalFeedCellDelegate{

    var _activityButton: UIButton!
    var _batsButton: UIButton!
    var _isInActivity : Bool = true
    
    var _feedMyBats : Array<PFObject> = []
    var _feedMyActivity : Array<PFObject> = []
    var _feed : [Array<PFObject>] = []
    var _currentIndex : ProfileFeedIndex = ProfileFeedIndex.MyActivity
    var activityRequest: Any = startFeedMyActivityRequest
    var myBastRequest: Any = startFeedMyBatsRequest
    var _arrRequest: [(()->())] = []

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        _feed = [_feedMyActivity, _feedMyBats]
        
        //activityButton.selected = true
        //batsButton.selected = false
        
        FBSDKAppEvents.logEvent(batEventProfilePageSelected)

        let titleDict: NSDictionary = [NSForegroundColorAttributeName:  UIColor(hexString: "46E0B5")]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
        
        var fnArr: [(()->())] = []
        _arrRequest = [startFeedMyActivityRequest, startFeedMyBatsRequest]
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        _arrRequest[_currentIndex.rawValue]()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func userProfileData(){
    
    
    }
    
    func batsButtonPressed(cell: BarCell) {

       // cell.batsButton.selected = true
      //  cell.activityButton.selected = false

        _isInActivity = false
        _currentIndex = ProfileFeedIndex.MyBats
        
        _arrRequest[_currentIndex.rawValue]()
        FBSDKAppEvents.logEvent(batEventMyBatsCategoryPressed)

        self.tableView.reloadData()

    }

    func activityButtonPressed(cell: BarCell) {
      //  cell.activityButton.selected = true
      //  cell.batsButton.selected = false

        _isInActivity = true
        _currentIndex = ProfileFeedIndex.MyActivity
        
        _arrRequest[_currentIndex.rawValue]()
        FBSDKAppEvents.logEvent(batEventMyActivityCategoryPressed)

        self.tableView.reloadData()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section == 0){
            return 1
        }
        else {
            println("count tab \(_feed[_currentIndex.rawValue].count) ")

            return _feed[_currentIndex.rawValue].count
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
            
            if (_currentIndex == ProfileFeedIndex.MyActivity){
                
                var activity = BatActivity(object:_feed[_currentIndex.rawValue][indexPath.row])
                println("type joke in activity \(activity.batJokeType)")
                // kPBatActivityBatJokeKey
                if (activity.batJokeType == kPBatJokeTypePunchline){
                    var cell = tableView.dequeueReusableCellWithIdentifier("ActivityCellPunchline", forIndexPath: indexPath) as! ActivityCell
                    var activity = BatActivity(object:_feed[_currentIndex.rawValue][indexPath.row])
                    
                    cell.configureWithActivity(activity)
                    return cell

                }else{
                    var cell = tableView.dequeueReusableCellWithIdentifier("ActivityCellMeme", forIndexPath: indexPath) as! ActivityCell
                    
                    
                    var activity = BatActivity(object:_feed[_currentIndex.rawValue][indexPath.row])
                    
                    cell.configureWithActivity(activity)
                    return cell

                }
            }
            else {
               // return configureBatsCells(indexPath)
                println("count \(_feed[_currentIndex.rawValue].count) && index \(indexPath.row)")
                var joke = BatJoke(object:_feed[_currentIndex.rawValue][indexPath.row])

                if (joke.type == kPBatJokeTypePunchline){
                    var cell = NSBundle.mainBundle().loadNibNamed("FeedTextCellView", owner: self, options: nil)[0] as! GlobalFeedCell
                    cell.delegate = self
                    cell.configureCellForProfileWith(joke)
                    return cell

                }
                else{
                    var cell = NSBundle.mainBundle().loadNibNamed("FeedImageCellView", owner: self, options: nil)[0] as! GlobalFeedCell
                    cell.delegate = self
                    cell.configureCellForProfileWith(joke)
                    return cell
                }
            }
        }
        
    }
    
    func didTapBat(joke: BatJoke, button: UIButton, cell: GlobalFeedCell, type: OpinionType) {
        // not called
    }
    
    
    func didDeleteBat(joke: BatJoke, cell: UITableViewCell) {
        
        
        var indexPath = self.tableView.indexPathForCell(cell)

        
        let alertController = UIAlertController(title: "Supprimer", message: "Êtes-vous sur de vouloir supprimer ce Bat ?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Non", style: .Cancel) { (action) in
            println(action)
        }
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Oui", style: .Destructive) { (action) in
            println(action)
            
            var query = PFQuery(className: kPBatActivityClassKey)
            query.whereKey(kPBatActivityBatJokeClassKey, equalTo: joke.object!)
            
            query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                if (error != nil){
                
                }
                else{
                    for(index, activity) in enumerate(objects as! Array<PFObject>){
                        (activity as PFObject).deleteInBackground()
                    }
                    self.deleteBatJoke(joke.object!, indexPath: indexPath!)
                }
            })
        }
        alertController.addAction(destroyAction)
        
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    
    
    func deleteBatJoke(jokeObject:PFObject, indexPath:NSIndexPath){
        jokeObject.deleteInBackgroundWithBlock({ (succeed, error) -> Void in
            if (succeed){
                self._feed[self._currentIndex.rawValue].removeAtIndex(indexPath.row)
                self.tableView.beginUpdates()
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.endUpdates()
                FBSDKAppEvents.logEvent(batEventBatsDeleted)
            }
        })
    }
    func didReportBat(joke: BatJoke, cell: UITableViewCell) {
        // not called

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
    
    
    func startBatscoreRequest(){
    
        var query : PFQuery =  PAPUtility.queryForActivitiesOnUser(PFUser.currentUser())
        

        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error != nil){
                
            }
            else{
                var dislikersCount = 0
                var likersCount = 0
                
                for(index, activity) in enumerate(objects as! Array<PFObject>){
                    
                    if((activity as PFObject).objectForKey(kPAPActivityTypeKey) as! String == kPAPActivityTypeDislike){
                        dislikersCount++
                    }
                    // like
                    if((activity as PFObject).objectForKey(kPAPActivityTypeKey) as! String == kPAPActivityTypeLike){
                        
                        likersCount++
                    }
                }
                var batscore = likersCount - dislikersCount
                
            }
        }
        
        
        
       
    }
    
    func startFeedMyActivityRequest(){
        
        var query : PFQuery = PFQuery(className: kPBatActivityClassKey)
        
        query.whereKey(kPBatActivityToUserKey, equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock ({(objects:[AnyObject]?, error: NSError?) in
            if(error == nil){
                self._feed[0].removeAll(keepCapacity: false)
                for object in objects! {
                    println(" object \(object)")
                    // verifier aucune activité de type report
                    self._feed[0].append(object as! PFObject)
                }
                self._feed[0] = self._feed[0].reverse()
                self.tableView.reloadData()
            }
            else{
                BatlingSingleton.sharedInstance.displayAlertWithText(self, text: "Impossible de récupérer le fil d'actualité, veuillez vérifier votre connexion à internet puis réessayer.")
            }
        })
    }
    
    func startFeedMyBatsRequest(){
        
        var query : PFQuery = PFQuery(className: kPBatJokeClassKey)
        println("currentuser id \(PFUser.currentUser()?.objectId)")
        query.whereKey(kPBatJokeUserKey, equalTo: PFUser.currentUser()!)
        query.findObjectsInBackgroundWithBlock ({(objects:[AnyObject]?, error: NSError?) in
            if(error == nil){
                self._feed[1].removeAll(keepCapacity: false)
                println("count objec \(objects?.count)")
                for object in objects! {
                    println(" object \(object)")
                    // verifier aucune activité de type report
                      self._feed[1].append(object as! PFObject)
                }
                self._feed[1] =   self._feed[1].reverse()
                
                self.tableView.reloadData()
            }
            else{
                
                BatlingSingleton.sharedInstance.displayAlertWithText(self, text: "Impossible de récupérer le fil d'actualité, veuillez vérifier votre connexion à internet puis réessayer.")
            }
        })
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
