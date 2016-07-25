//
//  SignInController.swift
//  TrackApp
//
//  Created by Max Bradley on 7/22/16.
//  Copyright © 2016 Max Bradley. All rights reserved.
//

import UIKit
import Firebase

class SignInController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var emailText: UITextField!
    
    @IBOutlet weak var googleSignIn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*try signing in when the user hits Sign In button */
    @IBAction func signIn(sender: UIButton) {
        FIRAuth.auth()?.signInWithEmail(emailText.text!, password: passwordText.text!) { (user:FIRUser?, error:NSError?) in
            if(error == nil){
                /*Sign in*/
                let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Map") as UIViewController
                self.presentViewController(vc, animated: true, completion: nil)
            } else {
                /*Show alert error box */
                let alertController = UIAlertController(title: "Error", message: "Invalid Credentials", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}
