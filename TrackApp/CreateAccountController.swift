//
//  CreateAccountController.swift
//  TrackApp
//
//  Created by Max Bradley on 7/22/16.
//  Copyright © 2016 Max Bradley. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountController: UIViewController {
    
    @IBOutlet var confirmPasswordText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var emailText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*Tries to create account with entered information */
    @IBAction func createAccount(sender: UIButton) {
        if (passwordText.text! == confirmPasswordText.text!){
            FIRAuth.auth()?.createUserWithEmail(emailText.text!, password: passwordText.text!) { (user:FIRUser?, error:NSError?) in
                if(error == nil){
                    /* Show TrackSelectionController */
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("Map") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Invalid Credentials", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title:"Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    
    }
}
