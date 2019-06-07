//
//  SignInPage.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 01/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit
import SQLite3
import GoogleSignIn
import FBSDKLoginKit

class SignInViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet var btnFacebook: UIButton!
    @IBOutlet var btnGoogle: UIButton!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad();
        GIDSignIn.sharedInstance().clientID = "282797941215-rkbfq9ufu9f471f603h5hqd6sg835trq.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btnGoogle.setImage(UIImage(named: "g".localizedKey()), for: .normal)
        self.btnFacebook.setImage(UIImage(named: "f".localizedKey()), for: .normal)

    }
    @IBAction func switchToSignUp(_ sender: Any) {
        let signUpView = storyboard?.instantiateViewController(withIdentifier: "signUpView") as! SignUpViewController;
        AppDelegate.sharedDelegate.switchToNewView(newViewController: signUpView, oldViewController: self);
        
    }
    
    //return true if everything is ok, otherwise returns false
    func checkInput() -> Bool{
        if(email.text!.count == 0){
            errorLabel.text = "An email is required".localizedKey();
            return false;
        }
        if(password.text!.count < 7){
            errorLabel.text = "Your password needs to be at least 7 characters long".localizedKey();
            return false;
        }
        return true;
    }
    
    @IBAction func logIn(_ sender: Any) {
        
        if  (checkInput()) {
           // API_SOCIALMEDIALOGIN
        let param = [
            "LoginEmailAddress"  : email.text!,
            "LoginPassword"      : password.text!,
            "AppVersion"         : "1.0.1",
            "ClientId"           : "",
            "DeviceType"         : "1",
            "ClientPNID"         : AppManager.getDeviceToken(),
            "DeviceId"           : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            print(parameter)
            ServerManager.shared.showHud(showInView: self.view, label: "")
            ServerManager.shared.httpPost(request: API_LOGIN, params: parameter, successHandler: { (JSON) in
                ServerManager.shared.hidHud()
                
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                   UserDefaults.SFSDefault(setValue: "0", forKey: "phone")
                    let userData = JSON["ResponseData"]
                    let currentUser = User.init(userData: userData)
                    AppManager.saveLoggedInUser(currentUser: currentUser)
                    UserDefaults.standard.set(true, forKey: kIsLogin)
                    
                    let loadingView = self.storyboard?.instantiateViewController(withIdentifier: "FetchingData_VC") as! FetchingData_VC
                    AppDelegate.sharedDelegate.switchToNewView(newViewController: loadingView, oldViewController: self)
                    
                }
                else {
                    let dic = responseError![0] as! NSDictionary
                    ServerManager.shared.hidHud()
                    AppManager.showErrorDialog(viewControler: self, message: dic.value(forKey: "ErrorMessage") as! String)
                }
                
            }) { (error) in
                ServerManager.shared.hidHud()
                AppManager.showErrorDialog(viewControler: self, message: AppManager.getErrorMessage(error!))
            }
            
        }
        }
    }
    
    @IBAction func accountRecoveryButtonPressed(_ sender: Any) {
        let accountRecoveryViewController = storyboard?.instantiateViewController(withIdentifier: "accountRecoveryView") as! AccountRecoveryViewController;
        AppDelegate.sharedDelegate.switchToNewView(newViewController: accountRecoveryViewController, oldViewController: self);
    }
    
    //MARK:
    //MARK: Login with Google
    
    @IBAction func logInWithGooglePressed(_ sender: Any) {
        
//        AppManager.showErrorDialog(viewControler: self, message: "Functionality not implemented. Coming soon!")
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK: Google Plus Mehtods
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
           
            GIDSignIn.sharedInstance().signOut()
            
             self.loginWithFB(ClientSocialTypeId: "2", ClientSocialId: user.userID, ClientFirstName: user.profile.givenName , ClientLastName: user.profile.familyName, ClientFullName: user.profile.name, ClientEmailAddress: user.profile.email )
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
    
    
    //MARK:
    //MARK: Login with Facebook
    
    @IBAction func loginWithFacebookBtnPressed(_ sender: Any) {
        
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        if((FBSDKAccessToken.current()) != nil){
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name,gender, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                                if (error == nil){
                                                                      
                                    let dict = result as! [String : AnyObject]
                                    print("facebookData \(dict)")
                                    let emailAddress =  dict["email"] as? String ?? ""
                                    let facebookID = dict["id"] as! String
                                    let firstName = dict["first_name"]as? String ?? ""
                                    let lastName = dict["last_name"]as? String ?? ""
                                    
                                    
                                    self.loginWithFB(ClientSocialTypeId: "1", ClientSocialId: facebookID, ClientFirstName: firstName, ClientLastName: lastName, ClientFullName: firstName + lastName, ClientEmailAddress: emailAddress)
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
}

extension SignInViewController {
    
    func loginWithFB(ClientSocialTypeId: String, ClientSocialId: String, ClientFirstName: String, ClientLastName: String, ClientFullName: String, ClientEmailAddress: String) {
        
        
        let param = [
            "ClientSocialTypeId"  : ClientSocialTypeId,
            "ClientSocialId"      : ClientSocialId,
            "ClientFirstName"     : ClientFirstName,
            "ClientLastName"      : ClientLastName,
            "ClientFullName"      : ClientFullName,
            "ClientEmailAddress"  : ClientEmailAddress,
            "AppVersion"          : "1.0.1",
            "ClientId"            : "",
            "DeviceType"          : "1",
            "RegistrationPNID"    : AppManager.getDeviceToken(),
            "ClientPNID"          : AppManager.getDeviceToken(),
            "DeviceId"            : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            
            ServerManager.shared.showHud(showInView: self.view, label: "")
            ServerManager.shared.httpPost(request: API_SOCIALMEDIALOGIN, params: parameter, successHandler: { (JSON) in
                ServerManager.shared.hidHud()
                
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                    UserDefaults.SFSDefault(setValue: "0", forKey: "phone")
                    let userData = JSON["ResponseData"]
                    let currentUser = User.init(userData: userData)
                    AppManager.saveLoggedInUser(currentUser: currentUser)
                    UserDefaults.SFSDefault(setBool: true, forKey: kIsLogin)
                    UserDefaults.SFSDefault(setBool: true, forKey: "isSocial")
                    
                    let loadingView = self.storyboard?.instantiateViewController(withIdentifier: "FetchingData_VC") as! FetchingData_VC
                    AppDelegate.sharedDelegate.switchToNewView(newViewController: loadingView, oldViewController: self)
                    
                }
                else {
                    let dic = responseError![0] as! NSDictionary
                    ServerManager.shared.hidHud()
                    AppManager.showErrorDialog(viewControler: self, message: dic.value(forKey: "ErrorMessage") as! String)
                }
                
            }) { (error) in
                ServerManager.shared.hidHud()
                AppManager.showErrorDialog(viewControler: self, message: AppManager.getErrorMessage(error!))
            }
            
            
        }
    }

}
