//
//  AccountRecoveryViewController.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 26/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit
import GoogleSignIn

class AccountRecoveryViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate;
    
    @IBOutlet var idField: UITextField!
    @IBOutlet var btnGoogle: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btnGoogle.setImage(UIImage(named: "g".localizedKey()), for: .normal)
    }

    @IBAction func nextButtonPressed(_ sender: Any) {
        let signInView = storyboard?.instantiateViewController(withIdentifier: "loginView") as! SignInViewController;
        appDelegate?.switchToNewView(newViewController: signInView, oldViewController: self);
    }
    
    @IBAction func AVTixHelpCenterPressed(_ sender: Any) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let signInView = storyboard?.instantiateViewController(withIdentifier: "loginView") as! SignInViewController;
        appDelegate?.switchToNewView(newViewController: signInView, oldViewController: self);
    }
    

    //MARK:
    //MARK: Login with Google
    
    @IBAction func logInWithGooglePressed(_ sender: Any) {
        
       // AppManager.showErrorDialog(viewControler: self, message: "Functionality not implemented. Coming soon!")
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK: Google Plus Mehtods
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            // let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            GIDSignIn.sharedInstance().signOut()
            
            let givenName = user.profile.givenName ?? ""
            let familyName = user.profile.familyName ?? ""
            let email = user.profile.email ?? ""
            //let username = user.profile.givenName ?? "" + user.profile.familyName
            
            if user.profile.hasImage == true {
                let thumbSize  = CGSize.init(width: 200, height: 200)
                let dimension = round(thumbSize.width * UIScreen.main.scale);
                _ = user.profile.imageURL(withDimension: UInt(dimension))
            }
            var parameter = Dictionary<String, String>()
            parameter["signup_type"] = "1"
            parameter["email"] = email
            parameter["username"] = fullName
            parameter["first_name"] = givenName
            parameter["last_name"] = familyName
            parameter["signup_type_id"] = userId
            parameter["device_type"] = "ios"
            parameter["device_token"] = AppManager.getDeviceToken()
            // self.loginWithFb(parameter: parameter)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
        GIDSignIn.sharedInstance().signOut()
    }
    
    //MARK: Google SignIn UIDelegate Methods
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //myActivityIndicator.stopAnimating()
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
