//
//  ChangePasswordViewController.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 04/11/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate;
    var parentVC : UIViewController!;
    
    @IBOutlet var email: UITextField!
    @IBOutlet var oldPassword: UITextField!
    @IBOutlet var newPassword: UITextField!
    @IBOutlet var newPasswordAgain: UITextField!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.text = loggedInUser.ClientEmailAddress
        email.isUserInteractionEnabled = false
    }
    
    @IBAction func changePassword(_ sender: Any) {
        UpdatePasswordChangeDataFromServer()
    }
    
    @IBAction func cancelChange(_ sender: Any) {
        let profileView = parentVC.storyboard?.instantiateViewController(withIdentifier: "profileNavigationView");
        appDelegate?.switchToNewView(newViewController: profileView!, oldViewController: self);
    }
}

extension ChangePasswordViewController {
    
    //MARK:
    //MARK: Change Password Loader
    func UpdatePasswordChangeDataFromServer() {
        if  (checkInput()) {
            
            let param = [
                "AppVersion"               : "1.0.1",
                "ClientId"                 : loggedInUser.ClientId,
                "DeviceType"               : "1",
                "ClientPNID"               : AppManager.getDeviceToken(),
                "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))",
                "EmailAddress"             : email.text!,
                "OldPassword"              : oldPassword.text!,
                "NewPassword"              : newPassword.text!
                ] as [String : Any]
            
            if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
                let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                print("JSON string = \n\(theJSONText)")
                let parameter  = ["clientPacket": theJSONText]
                ServerManager.shared.showHud(showInView: self.view, label: "")
                ServerManager.shared.httpPost(request: "\(API_PASSWORDCHANGE)", params: parameter, successHandler: { (JSON) in
                    ServerManager.shared.hidHud()
                    let responseError = JSON["ResponseErrors"].arrayObject
                   
                    if responseError?.count == 0 {
                        
//                        let userData = JSON["ResponseData"]
                        
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
     
        if(email.text!.count == 0) {
            errorLabel.text = "An email is required".localizedKey();
            return false;
        }
        if(oldPassword.text!.count < 7) {
            errorLabel.text = "An old Password is required".localizedKey();
            return false;
        }
        if (newPassword.text!.count < 7) {
            errorLabel.text = "Your password needs to be at least 7 characters long".localizedKey();
            return false;
        }
        if(newPasswordAgain.text != newPassword.text) {
            errorLabel.text = "Passwords do not match".localizedKey();
            return false;
        }
        return true;
    }
    
}
