//
//  CountryPicker.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 14/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

class ProfileDataController : UIView {
    
    @IBOutlet weak var btn_ChangePassword: UIButton!
    
    var profileViewController : ProfileViewController!;    
    @IBOutlet var displayName: UITextField!
    @IBOutlet var firstName:   UITextField!
    @IBOutlet var lastName:    UITextField!
    @IBOutlet var email:       UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var errorLabel:  UILabel!
    
    func setUpProfileView(){
        
        displayName.text = loggedInUser.ClientDisplayName
        firstName.text   = loggedInUser.ClientFirstName
        lastName.text    = loggedInUser.ClientLastName
        email.text       = loggedInUser.ClientEmailAddress
        var str_Phone    = loggedInUser.ClientPhoneNumber
        if  str_Phone == "" {
            str_Phone = UserDefaults.SFSDefault(valueForKey: "phone") as! String
            if str_Phone == "0" {
                str_Phone = ""
            }
        }
         self.btn_ChangePassword.isHidden = false
        if UserDefaults.SFSDefault(boolForKey: "isSocial") == true {
            self.btn_ChangePassword.isHidden = true
        }
        phoneNumber.text = str_Phone
        email.isUserInteractionEnabled = false
        phoneNumber.isUserInteractionEnabled = false
    }
    
    @IBAction func updatePersonalInfo(_ sender: Any) {
        UpdateAccountDetailsDataFromServer()
    }
    
    @IBAction func changePassword(_ sender: Any) {
        let passChangeView = Bundle.main.loadNibNamed("ChangePassword", owner: self, options: nil)?.first as! ChangePasswordViewController
        passChangeView.parentVC = profileViewController
        AppDelegate.sharedDelegate.switchToNewView(newViewController: passChangeView, oldViewController: profileViewController)
    }
    
    @IBAction func confirmPhoneNumber(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
//        let vc = AppDelegate.sharedDelegate.getViewControllerFromCustomer(viewControllerName: "PhoneNumber_VC") as! PhoneNumber_VC
//
//       // vc.parentVC = profileViewController
//        AppDelegate.sharedDelegate.switchToNewView(newViewController: vc, oldViewController: profileViewController)
       
    }
   
  
}

extension ProfileDataController {
    
    //MARK:
    //MARK: Change Password Loader
    func UpdateAccountDetailsDataFromServer() {
        if  (checkInput()) {
            
            let param = [
                "AppVersion"               : "1.0.1",
                "ClientId"                 : loggedInUser.ClientId,
                "DeviceType"               : "1",
                "ClientPNID"               : AppManager.getDeviceToken(),
                "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))",
                "ClientEmailAddress"       : email.text!,
                "ClientFirstName"          : firstName.text!,
                "ClientLastName"           : lastName.text!,
                "ClientDisplayName"        : displayName.text!
                ] as [String : Any]
            
            if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
                let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                print("JSON string = \n\(theJSONText)")
                let parameter  = ["clientPacket": theJSONText]
                ServerManager.shared.showHud(showInView: self, label: "")
                ServerManager.shared.httpPost(request: "\(API_CLIENTUPDATE)", params: parameter, successHandler: { (JSON) in
                    ServerManager.shared.hidHud()
                    let responseError = JSON["ResponseErrors"].arrayObject
                    
                    if responseError?.count == 0 {
                        
                        let userData = JSON["ResponseData"]
                        let currentUser = User.init(userData: userData)
                        AppManager.saveLoggedInUser(currentUser: currentUser)
                        
                    }
                    else {
                       // let dic = responseError![0] as! NSDictionary
                        ServerManager.shared.hidHud()
                       // AppManager.showErrorDialog(viewControler: self, message: dic.value(forKey: "ErrorMessage") as! String)
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
            errorLabel.text = "DisplayName is required".localizedKey();
            return false;
        }
        if(firstName.text!.count == 0){
            errorLabel.text = "FirstName is required".localizedKey();
            return false;
        }
        if(lastName.text!.count == 0){
            errorLabel.text = "LastName is required".localizedKey();
            return false;
        }
        return true;
    }
}
