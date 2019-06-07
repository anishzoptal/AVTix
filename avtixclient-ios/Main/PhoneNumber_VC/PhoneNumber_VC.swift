//
//  PhoneNumber_VC.swift
//  avtixclient-ios
//
//  Created by eshan Cheema on 03/12/18.
//  Copyright © 2018 avtixclient-ios. All rights reserved.

import UIKit

class PhoneNumber_VC: UIViewController {

    var parentVC : UIViewController!;
    var phoneViewController : PhoneNumber_VC!;
    @IBOutlet weak var tf_PhoneNo: UITextField!
    @IBOutlet weak var tf_CountryCode: UITextField!
    @IBOutlet weak var tf_Country: UITextField!
    let datePickerView:UIPickerView = UIPickerView()
    
    var arr_CountryList =  NSArray()
    
    func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "CountryCodes", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                    arr_CountryList = object as NSArray
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        readJson()
      
        datePickerView.dataSource = self
        datePickerView.delegate = self
        tf_Country.attributedPlaceholder = NSAttributedString(string: "SELECT COUNTRY".localizedKey(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        
        tf_Country.inputView = datePickerView
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SaveBtnAction(_ sender: Any) {
   
       
        FetchPhoneActiviteDataFromServer()
    }
    
    @IBAction func CancelBtnAction(_ sender: Any) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.popViewController(animated: true)
//        let profileView = parentVC.storyboard?.instantiateViewController(withIdentifier: "profileNavigationView");
//        AppDelegate.sharedDelegate.switchToNewView(newViewController: profileView!, oldViewController: self);
    }
}


extension PhoneNumber_VC: UIPickerViewDelegate , UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return arr_CountryList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dic = arr_CountryList[row] as! NSDictionary
        return dic.value(forKey: "name") as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let dic = arr_CountryList[row] as! NSDictionary
        tf_Country.text = dic.value(forKey: "name") as? String
        tf_CountryCode.text = dic.value(forKey: "dial_code") as? String
       // self.view.endEditing(true)
    }
    
}

extension PhoneNumber_VC {
    
    //return true if everything is ok, otherwise returns false
    func checkInput() -> Bool{
        if(tf_Country.text!.count == 0){
            AppManager.showErrorDialog(viewControler: self, message: "Country is required".localizedKey())
            return false;
        }
        if(tf_CountryCode.text!.count == 0){
            AppManager.showErrorDialog(viewControler: self, message: "Country Code is required".localizedKey())
            return false;
        }
        if(tf_PhoneNo.text!.count == 0){
            AppManager.showErrorDialog(viewControler: self, message: "Phone number is required".localizedKey())
            return false;
        }
        return true;
    }
    //MARK:
    //MARK: Fetch data from Phone Activite Loader
    func FetchPhoneActiviteDataFromServer() {
       
        if checkInput() {
            
            let param = [
                "AppVersion"               : "1.0.1",
                "ClientId"                 : loggedInUser.ClientId,
                "DeviceType"               : "1",
                "ClientPNID"               : AppManager.getDeviceToken(),
                "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))",
                "CountryCode"              : tf_CountryCode.text!,
                "PhoneNumber"              : "\(tf_CountryCode.text!)\(tf_PhoneNo.text!)"
                ] as [String : Any]
            
            if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
                let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
                print("JSON string = \n\(theJSONText)")
                let parameter  = ["clientPacket": theJSONText]
                ServerManager.shared.httpPost(request: "\(API_PHONEACTIVATE)", params: parameter, successHandler: { (JSON) in
                    ServerManager.shared.hidHud()
                    
                    let responseError = JSON["ResponseErrors"].arrayObject
                    
                    if responseError?.count == 0 {
                        UserDefaults.SFSDefault(setValue: self.tf_PhoneNo.text!, forKey: "phone")
                        let vc = AppDelegate.sharedDelegate.getViewControllerFromCustomer(viewControllerName: "ActivationPhone_VC") as! ActivationPhone_VC
                       self.navigationController?.pushViewController(vc, animated: true)
                        return
                    }
                    else {
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
