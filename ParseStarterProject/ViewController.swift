/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet var username: UITextField!
    
    @IBAction func signIn(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(username.text!, password:"myPass") {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                
                print("logged in")
                self.performSegueWithIdentifier("showUsers", sender: self)
                
            } else {
                
                var user = PFUser()
                user.username = self.username.text
                user.password = "myPass"
                
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if error == nil {
                        
                        
                        print("signed up")
                        
                        self.performSegueWithIdentifier("showUsers", sender: self)
                        
                    } else {
                        
                        print(error)
                        
                    }
                }
                
                
            }
        }
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
        
            
            
            self.performSegueWithIdentifier("showUsers", sender: self)

        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
