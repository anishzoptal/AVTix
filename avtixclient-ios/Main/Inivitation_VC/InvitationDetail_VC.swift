//
//  InvitationDetail_VC.swift
//  avtixclient-ios
//
//  Created by eshan Cheema on 14/12/18.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class InvitationDetail_VC: UIViewController {

    @IBOutlet weak var lbl_Description: UILabel!
    @IBOutlet weak var lbl_Location: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var img_Background: UIImageView!
    
    var dic_Invitation = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lbl_Description.text = dic_Invitation.value(forKey: "description") as? String
        lbl_Name.text = dic_Invitation.value(forKey: "title") as? String
        lbl_Location.text = dic_Invitation.value(forKey: "location") as? String
        let str_StartDate = AppManager.getFormatedDateFullMonthFromString(currentdate: "\(dic_Invitation.value(forKey: "valid")!)")
        lbl_Date.text = str_StartDate
        let str_TimeDate = AppManager.getFormatedTimeFromString(currentdate: "\(dic_Invitation.value(forKey: "valid")!)")
        lbl_Time.text = str_TimeDate
        // Do any additional setup after loading the view.
    }
    

    @IBAction func LaterBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func AcceptedBtnAction(_ sender: Any) {
        FetchInvitationUpdatesDataFromServer(isBool: true, str_Id: dic_Invitation.value(forKey: "id") as? String)
       // DBManager.getSharedInstance()?.updateInvitation("\(dic_Invitation.value(forKey: "id")!)", invitationAccepted: "1")
    }
    
    @IBAction func RejectedBtnAction(_ sender: Any) {
        FetchInvitationUpdatesDataFromServer(isBool: false, str_Id: dic_Invitation.value(forKey: "id") as? String)
        //DBManager.getSharedInstance()?.updateInvitation("\(dic_Invitation.value(forKey: "id")!)", invitationAccepted: "0")
    }
}


extension InvitationDetail_VC {
    
    func FetchInvitationUpdatesDataFromServer(isBool: Bool, str_Id: String!) {
        
        let param = [
            "AppVersion"          : "1.0.1",
            "ClientId"            : loggedInUser.ClientId,
            "DeviceType"          : "1",
            "ClientPNID"          : AppManager.getDeviceToken(),
            "DeviceId"            : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))",
            "InviteId"            : str_Id,
            "InviteAccepted"      : isBool
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            ServerManager.shared.showHud(showInView: self.view, label: "")
            ServerManager.shared.httpPost(request: "\(API_INVITATIONUPDATE)", params: parameter, successHandler: { (JSON) in
                   ServerManager.shared.hidHud()
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            }) { (error) in
                ServerManager.shared.hidHud()
                print(error.debugDescription)
                AppManager.showErrorDialog(viewControler: self, message:error.debugDescription)
            }
        }
    }
}
