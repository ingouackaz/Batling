//
//  NewPunchlineVC.swift
//  Batling
//
//  Created by Ingouackaz on 2015-05-30.
//  Copyright (c) 2015 Ingouackaz. All rights reserved.
//

import UIKit

class NewPunchlineVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var punchlineTextView: SZTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        punchlineTextView.becomeFirstResponder()

        // Do any additional setup after loading the view.
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
