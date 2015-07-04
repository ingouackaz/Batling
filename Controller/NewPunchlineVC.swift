//
//  NewPunchlineVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-30.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class NewPunchlineVC: UIViewController, UITextViewDelegate {

    var _kbIsUp : Bool = false
    var kbHeight: CGFloat!


    @IBOutlet weak var punchlineTextView: SZTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        punchlineTextView.layer.borderWidth = 1.0
        punchlineTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        punchlineTextView.becomeFirstResponder()
       // punchlineTextView.textContainer.lineBreakMode = NSLineBreakMode.ByTruncatingTail;

        //punchlineTextView.textContainer.maximumNumberOfLines = 9
      //  self.punchlineTextView.textContainer.maximumNumberOfLines = 10

        
            //    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
      //        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if (_kbIsUp == false){
            _kbIsUp = true
            if let userInfo = notification.userInfo {
                if let keyboardSize =  (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                    kbHeight = keyboardSize.height / 2
                    self.animateTextField(true)
                }
            }
        }
    }
    
    
    /*
    - (BOOL) textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
    {
    static const NSUInteger MAX_NUMBER_OF_LINES_ALLOWED = 3;
    
    NSMutableString *t = [NSMutableString stringWithString:
    self.textView.text];
    [t replaceCharactersInRange: range withString: text];
    
    NSUInteger numberOfLines = 0;
    for (NSUInteger i = 0; i < t.length; i++) {
    if ([[NSCharacterSet newlineCharacterSet]
    characterIsMember: [t characterAtIndex: i]]) {
    numberOfLines++;
    } =
    }
    
    return (numberOfLines < MAX_NUMBER_OF_LINES_ALLOWED);
    }
    */
    var _previousRect : CGRect = CGRectZero
    
    func textViewDidChange(textView: UITextView) {
        
        FBSDKAppEvents.logEvent(batEventPunchlineStartTyping)
        
        var pos : UITextPosition = textView.endOfDocument
        
        var currentRect : CGRect = textView.caretRectForPosition(pos)
        
        
        if (currentRect.origin.y>_previousRect.origin.y){
            println("new line reached h \(currentRect.origin.y)")
        }
        else{
            println("normalf h \(currentRect.origin.y)")

        }
        if (currentRect.origin.y > 140){
            textView.text.substringToIndex(textView.text.endIndex.predecessor())
        }
        _previousRect = currentRect

    }

    func keyboardWillHide(notification: NSNotification) {
        
        if (_kbIsUp == true){
            _kbIsUp = false
            self.animateTextField(false)
        }
        
    }
    
    func animateTextField(up: Bool) {
        var movement = (up ? -kbHeight : kbHeight)
        
        UIView.animateWithDuration(0.6, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }

    

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        punchlineTextView.resignFirstResponder()        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        punchlineTextView.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        punchlineTextView.resignFirstResponder()
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
