//
//  ActivationPhone_VC.swift
//  avtixclient-ios
//
//  Created by eshan Cheema on 06/12/18.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class ActivationPhone_VC: UIViewController {

    var parentVC : UIViewController!;
    @IBOutlet weak var tf_Activation: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ConfirmBtnAction(_ sender: Any) {
   
        FetchPhoneConfirmDataFromServer()
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        UserDefaults.SFSDefault(setValue: "0", forKey: "phone")
        self.navigationController?.popViewController(animated: true)
    }
}

extension ActivationPhone_VC {
    
    //return true if everything is ok, otherwise returns false
    func checkInput() -> Bool{
        if(tf_Activation.text!.count == 0){
            AppManager.showErrorDialog(viewControler: self, message: "Activation Code is required".localizedKey())
            return false;
        }
       
        return true;
    }
    
    //MARK:
    //MARK: Fetch data from Phone Confirm Loader
    func FetchPhoneConfirmDataFromServer() {
        
        if checkInput() {
            let param = [
                "AppVersion"               : "1.0.1",
                "ClientId"                 : loggedInUser.ClientId,
                "DeviceType"               : "1",
                "ClientPNID"               : AppManager.getDeviceToken(),
                "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))",
                "ActivationCode"           : tf_Activation.text!
                ] as [String : Any]
            
            if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
                let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                print("JSON string = \n\(theJSONText)")
                let parameter  = ["clientPacket": theJSONText]
                ServerManager.shared.httpPost(request: "\(API_PHONECONFIRM)", params: parameter, successHandler: { (JSON) in
                    ServerManager.shared.hidHud()
                    
                    let responseError = JSON["ResponseErrors"].arrayObject
                    
                    if responseError?.count == 0 {
                        
                        let mainNavigationView = self.storyboard?.instantiateViewController(withIdentifier: "mainNavigationView") as! MainNavigationController
                        AppDelegate.sharedDelegate.switchToNewView(newViewController: mainNavigationView, oldViewController: self)
                    }
                    else {
                        UserDefaults.SFSDefault(setValue: "0", forKey: "phone")
                        let dic = responseError![0] as! NSDictionary
                        ServerManager.shared.hidHud()
                        AppManager.showErrorDialog(viewControler: self, message: dic.value(forKey: "ErrorMessage") as! String)
                    }
                    
                }) { (error) in
                    print(error.debugDescription)
                    ServerManager.shared.hidHud()
                    AppManager.showErrorDialog(viewControler: self, message: "\(error.debugDescription)")
                }
            }
        }
    }
}
