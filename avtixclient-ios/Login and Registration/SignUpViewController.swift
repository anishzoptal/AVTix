//
//  SignUpView.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 02/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

class SignUpViewController: UIViewController {

    
    @IBOutlet var displayName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var passwordAgain: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
    }
    
    @IBAction func switchToSignIn(_ sender: Any) {
        let signInView = storyboard?.instantiateViewController(withIdentifier: "loginView") as! SignInViewController;
        AppDelegate.sharedDelegate.switchToNewView(newViewController: signInView, oldViewController: self);
    }
    
    @IBAction func signUp(_ sender: Any) {
        
        if(checkInput()){
            
            let param = [
                "RegistrationDisplayName"  : displayName.text!,
                "RegistrationFirstName"    : "",
                "RegistrationLastName"     : "",
                "RegistrationEmailAddress" : email.text!,
                "RegistrationPassword"     : password.text!,
                "AppVersion"               : "1.0.1",
                "ClientId"                 : "",
                "DeviceType"               : "1",
                "RegistrationPNID"         : AppManager.getDeviceToken(),
                "ClientPNID"               : AppManager.getDeviceToken(),
                "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
                ] as [String : Any]
            
            if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
                let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                print("JSON string = \n\(theJSONText)")
                let parameter  = ["clientPacket": theJSONText]
                ServerManager.shared.httpPost(request: "\(API_REGISTER)", params: parameter, successHandler: { (JSON) in
                    ServerManager.shared.hidHud()
                    let responseError = JSON["ResponseErrors"].arrayObject
                    
                    if responseError?.count == 0 {
                        UserDefaults.SFSDefault(setValue: "0", forKey: "phone")
                        let userData = JSON["ResponseData"]
                        let currentUser = User.init(userData: userData)
                        AppManager.saveLoggedInUser(currentUser: currentUser)
                        UserDefaults.standard.set(true, forKey: kIsLogin)

                        let loadingView = self.storyboard?.instantiateViewController(withIdentifier: "FetchingData_VC") as! FetchingData_VC
                        AppDelegate.sharedDelegate.switchToNewView(newViewController: loadingView, oldViewController: self);
                    }
                    else {
                        let dic = responseError![0] as! NSDictionary
                        ServerManager.shared.hidHud()
                        AppManager.showErrorDialog(viewControler: self, message: dic.value(forKey: "ErrorMessage") as! String)
                    }
                
                }) { (error) in
                    print(error.debugDescription)
                }
            }
        }
    }
    
    //return true if everything is ok, otherwise returns false
    func checkInput() -> Bool{
        if(displayName.text!.count == 0){
            errorLabel.text = "A display name is required".localizedKey();
            return false;
        }
        if(email.text!.count == 0){
            errorLabel.text = "An email is required".localizedKey();
            return false;
        }
        if(password.text!.count < 7){
            errorLabel.text = "Your password needs to be at least 7 characters long".localizedKey();
            return false;
        }
        if(passwordAgain.text != password.text){
            errorLabel.text = "Passwords do not match".localizedKey();
            return false;
        }
        return true;
    }
}
