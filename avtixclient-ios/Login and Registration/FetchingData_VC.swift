//
//  FetchingData_VC.swift
//  avtixclient-ios
//
//  Created by eshan Cheema on 28/11/18.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class FetchingData_VC: UIViewController {

    @IBOutlet weak var lbl_FetchingData: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

//        let nc = NotificationCenter.default
//        nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
        
       
         AppManager.getLoggedInUser()
        if loggedInUser.ClientPhoneNumber == "" {
            UserDefaults.SFSDefault(setValue: "0", forKey: "phone")
        }
        DBManager.getSharedInstance()?.deleteinformationbydate("", value: "26/11/2018")
        lbl_FetchingData.text = "Loading Background......".localizedKey()
        FetchBackgroundDataFromServer()
        // Do any additional setup after loading the view.
    }

}

extension FetchingData_VC {
    //MARK:
    //MARK: Fetch data from Background Loader
    func FetchBackgroundDataFromServer() {
        
        var is_API = false
        let param = [
            "AppVersion"               : "1.0.1",
            "ClientId"                 : loggedInUser.ClientId,
            "DeviceType"               : "1",
            "ClientPNID"               : AppManager.getDeviceToken(),
            "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
           
            ServerManager.shared.showHud(showInView: self.view, label: "")
            ServerManager.shared.httpPost(request: "\(API_LOADBACKGROUNDS)", params: parameter, successHandler: { (JSON) in
                //ServerManager.shared.hidHud()
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if is_API == false {
                    is_API = true
                    self.lbl_FetchingData.text = "Loading Tickets......".localizedKey()
                    self.FetchTicketsDataFromServer()
                }
                
                
                if responseError?.count == 0 {
                    var is_Yes = true
                   // var i = 0
                    let userData = JSON["ResponseData"]
                    
                    let dic = userData[0].dictionaryValue
                    DBManager.getSharedInstance()?.saveAvBackgroundData(
                        "\(dic["BackgroundId"]!)",
                        backgroundName:      "\(dic["BackgroundName"]!)",
                        backgroundCategory:  "\(dic["BackgroundCategoryId"]!)",
                        backgroundType:      "\(dic["BackgroundTypeId"]!)",
                        backgroundUrl:       "\(dic["BackgroundUrl"]!)",
                        backgroundDefault:   "\(dic["BackgroundDefault"]!)",
                        backgroundData:      "",
                        date:                "26/11/2018")
                  
                    if is_Yes == true {
                        DBManager.getSharedInstance()?.deleteinformationbydate("", value: "26/11/2018")
                        is_Yes = false
                        
                    }
                    
                    for  index in 0..<userData.count {
                        let dic = userData[index].dictionaryValue
                        
                        DBManager.getSharedInstance()?.saveAvBackgroundData(
                                                 "\(dic["BackgroundId"]!)",
                            backgroundName:      "\(dic["BackgroundName"]!)",
                            backgroundCategory:  "\(dic["BackgroundCategoryId"]!)",
                            backgroundType:      "\(dic["BackgroundTypeId"]!)",
                            backgroundUrl:       "\(dic["BackgroundUrl"]!)",
                            backgroundDefault:   "\(dic["BackgroundDefault"]!)",
                            backgroundData:      "",
                            date:                "26/11/2018")
        
                    }
                }
                else {
//                    let dic = responseError![0] as! NSDictionary
                   // ServerManager.shared.hidHud()
                   // AppManager.showErrorDialog(viewControler: self, message: dic.value(forKey: "ErrorMessage") as! String)
                }
                
            }) { (error) in
                print(error.debugDescription)
            }
        }
    }
}

extension FetchingData_VC {
    
    //MARK:
    //MARK: Fetch data from Tickets Loader
    
    func FetchTicketsDataFromServer() {
        var is_API = false
        
        let param = [
            "AppVersion"               : "1.0.1",
            "ClientId"                 : loggedInUser.ClientId,
            "DeviceType"               : "1",
            "ClientPNID"               : AppManager.getDeviceToken(),
            "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            ServerManager.shared.httpPost(request: "\(API_LOADTICKETS)", params: parameter, successHandler: { (JSON) in
              //  ServerManager.shared.hidHud()
                if is_API == false {
                    is_API = true
                    self.lbl_FetchingData.text = "Loading Invitations......".localizedKey()
                    self.FetchInvitationsDataFromServer()
                }
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                    
                    let userData = JSON["ResponseData"]
                    
                    for  index in 0..<userData.count {
                        let dic = userData[index].dictionaryValue
                        
                        DBManager.getSharedInstance()?.saveAvTicketsData(
                                            "\(dic["TicketId"]!)",
                            ticketManualId: "\(dic["TicketManualId"]!)",
                            ticketType:     "\(dic["TicketTypeName"]!)",
                            ticketAmount:   "",
                            eventName:      "\(dic["EventName"]!)",
                            eventLocation:  "\(dic["EventLocation"]!)",
                            eventStartDate: "\(dic["EventStartDate"]!)",
                            eventEndDate:   "\(dic["EventEndDate"]!)",
                            eventCategory:  "\(dic["EventCategoryId"]!)",
                            upGradeEnable:  "\(dic["UpgradeEnabled"]!)",
                            chatEnabled:    "\(dic["ChatEnabled"]!)",
                            rateEnabled:    "\(dic["RateEnabled"]!)",
                            backgroundCode: "\(dic["BackgroundCode"]!)",
                            receivedDate:   "\(dic["SpecialValue"]!)",
                            userDate:       "",
                            usedBy:         "",
                            pinEntry:       "",
                            usedSendDate:   "",
                            usedSendLog:    "",
                            date:           "26/11/2018")
                    }
                   
                }
                else {

                }
                
            }) { (error) in
                print(error.debugDescription)
            }
        }
    }
}

extension FetchingData_VC {
    
    //MARK:
    //MARK: Fetch data from Invitations Loader
    func FetchInvitationsDataFromServer() {
        
        DBManager.getSharedInstance()?.saveAvInvitesData(
            "2",
            inviteTitle:       "B'day Partyyy",
            inviteLocation:    "Mohali",
            inviteDescription: "CEO's B'day Party......",
            inviteCategory:    "3",
            inviteDate:        "2018-12-23T03:33:22Z",
            inviteValidDate:   "2018-12-25T03:33:22Z",
            inviteBackground:  "0",
            inviteAccepted:    "0",
            date:              "26/11/2018")
        
        var is_API = false
        let param = [
            "AppVersion"               : "1.0.1",
            "ClientId"                 : loggedInUser.ClientId,
            "DeviceType"               : "1",
            "ClientPNID"               : AppManager.getDeviceToken(),
            "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            ServerManager.shared.httpPost(request: "\(API_LOADINVITATIONS)", params: parameter, successHandler: { (JSON) in
               // ServerManager.shared.hidHud()
                if is_API == false {
                    is_API = true
                    self.lbl_FetchingData.text = "Loading Promotions......".localizedKey()
                    self.FetchPromotionsDataFromServer()
                }
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                    
                    let userData = JSON["ResponseData"]
                    for  index in 0..<userData.count {
                        let dic = userData[index].dictionaryValue
                        
                        DBManager.getSharedInstance()?.saveAvInvitesData(
                                               "\(dic["InviteId"]!)",
                            inviteTitle:       "\(dic["InviteTitle"]!)",
                            inviteLocation:    "\(dic["InviteLocation"]!)",
                            inviteDescription: "\(dic["InviteDescription"]!)",
                            inviteCategory:    "\(dic["InviteCategoryId"]!)",
                            inviteDate:        "\(dic["InviteDate"]!)",
                            inviteValidDate:   "\(dic["InviteExpireDate"]!)",
                            inviteBackground:  "\(dic["InviteBackgroundId"]!)",
                            inviteAccepted:    "\(dic["InviteAccepted"]!)",
                            date:              "26/11/2018")
                    }
        
                }
                else {
//                    let dic = responseError![0] as! NSDictionary
//                    ServerManager.shared.hidHud()
//                    AppManager.showErrorDialog(viewControler: self, message: dic.value(forKey: "ErrorMessage") as! String) e75740aa94e207c5030b5a995638b97f3aa101c4
                }
                
            }) { (error) in
                print(error.debugDescription)
            }
        }
    }
}

extension FetchingData_VC {
    
    //MARK:
    //MARK: Fetch data from Promotions Loader
    func FetchPromotionsDataFromServer() {
        
        var is_API = false
        let param = [
            "AppVersion"               : "1.0.1",
            "ClientId"                 : loggedInUser.ClientId,
            "DeviceType"               : "1",
            "ClientPNID"               : AppManager.getDeviceToken(),
            "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            ServerManager.shared.httpPost(request: "\(API_LOADPROMOTIONS)", params: parameter, successHandler: { (JSON) in
              //  ServerManager.shared.hidHud()
                if is_API == false {
                    is_API = true
                    self.lbl_FetchingData.text = "Loading Events......".localizedKey()
                    self.FetchEventsDataFromServer()
                }
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                    
                    let userData = JSON["ResponseData"]
                    for  index in 0..<userData.count {
                        let dic = userData[index].dictionaryValue
                        
                        DBManager.getSharedInstance()?.saveAvPromotionsData(
                                              "\(dic["PromoId"]!)",
                            promoName:        "\(dic["PromoName"]!)",
                            promoDescription: "\(dic["PromoDescription"]!)",
                            promoFromDate:    "\(dic["PromoFromDate"]!)",
                            promoToDate:      "\(dic["PromoToDate"]!)",
                            promoUrl:         "\(dic["PromoUrl"]!)",
                            promoImageUrl:    "\(dic["PromoImageUrl"]!)",
                            promoImageData:   "\(dic["PromoImageUrl"]!)",
                            date:             "26/11/2018")
                    }
                   
                }
                else {
//                    let dic = responseError![0] as! NSDictionary
//                    ServerManager.shared.hidHud()
//                    AppManager.showErrorDialog(viewControler: self, message: dic.value(forKey: "ErrorMessage") as! String)
                }
                
            }) { (error) in
                print(error.debugDescription)
            }
        }
    }
}

extension FetchingData_VC {
    
    //MARK:
    //MARK: Fetch data from Events Loader
    func FetchEventsDataFromServer() {
        var is_API = false
        let param = [
            "AppVersion"               : "1.0.1",
            "ClientId"                 : loggedInUser.ClientId,
            "DeviceType"               : "1",
            "ClientPNID"               : AppManager.getDeviceToken(),
            "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            ServerManager.shared.httpPost(request: "\(API_LOADEVENTS)", params: parameter, successHandler: { (JSON) in
               // ServerManager.shared.hidHud()
                if is_API == false {
                    is_API = true
                    self.lbl_FetchingData.text = "Loading Categories......".localizedKey()
                    self.FetchCategoriesDataFromServer()
                }
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                    
                    let userData = JSON["ResponseData"]
                    for  index in 0..<userData.count {
                        let dic = userData[index].dictionaryValue
                        
                        DBManager.getSharedInstance()?.saveAvEventsData(
                                              "\(dic["EventId"]!)",
                            eventName:        "\(dic["EventName"]!)",
                            eventDescription: "\(dic["EventDescription"]!)",
                            eventCategory:    "\(dic["EventCategoryId"]!)",
                            eventLocation:    "\(dic["EventLocation"]!)",
                            eventStartDate:   "\(dic["EventStartDate"]!)",
                            eventEndDate:     "\(dic["EventEndDate"]!)",
                            eventUrl:         "\(dic["EventUrl"]!)",
                            eventImageUrl:    "\(dic["EventImageUrl"]!)",
                            eventImageData:   "\(dic["EventImageUrl"]!)",
                            date:             "26/11/2018")//
                        
                    }
                    
                }
                else {
//                    let dic = responseError![0] as! NSDictionary
//                    ServerManager.shared.hidHud()
//                    AppManager.showErrorDialog(viewControler: self, message: dic.value(forKey: "ErrorMessage") as! String)
                }
                
            }) { (error) in
                print(error.debugDescription)
            }
        }
    }
}

extension FetchingData_VC {
    
    //MARK:
    //MARK: Fetch data from Categories Loader
    func FetchCategoriesDataFromServer() {
       
        DBManager.getSharedInstance()?.saveAvCategoriesData(
            "0",
            categoryName:    "Upcoming",
            categoryOrderId: "0",
            date:            "26/11/2018")//
        var is_API = false
        
        let param = [
            "AppVersion"               : "1.0.1",
            "ClientId"                 : loggedInUser.ClientId,
            "DeviceType"               : "1",
            "ClientPNID"               : AppManager.getDeviceToken(),
            "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            ServerManager.shared.httpPost(request: "\(API_LOADCATEGORIES)", params: parameter, successHandler: { (JSON) in
                //ServerManager.shared.hidHud()
                
                if is_API == false {
                    is_API = true
                    self.lbl_FetchingData.text = "Loading ......".localizedKey()
                    self.FetchAccountRecoverDataFromServer()
                }
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                    
                    let userData = JSON["ResponseData"]
                    for  index in 0..<userData.count {
                        let dic = userData[index].dictionaryValue
                        
                        DBManager.getSharedInstance()?.saveAvCategoriesData(
                                             "\(dic["CategoryId"]!)",
                            categoryName:    "\(dic["CategoryName"]!)",
                            categoryOrderId: "\(dic["CategoryOrderId"]!)",
                            date:            "26/11/2018")
                        
                    }
                    
                }
                
            }) { (error) in
                print(error.debugDescription)
            }
        }
    }
}

extension FetchingData_VC {
    
    //MARK:
    //MARK: Fetch data from Account Recover Loader
    func FetchAccountRecoverDataFromServer() {
        
        var is_API = false
        let param = [
            "AppVersion"               : "1.0.1",
            "ClientId"                 : loggedInUser.ClientId,
            "DeviceType"               : "1",
            "ClientPNID"               : AppManager.getDeviceToken(),
            "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            ServerManager.shared.httpPost(request: "\(API_ACCOUNTRECOVER)", params: parameter, successHandler: { (JSON) in
              //  ServerManager.shared.hidHud()
                if is_API == false {
                    is_API = true
                    self.lbl_FetchingData.text = "Loading ......".localizedKey()
                 self.FetchInvitationUpdatesDataFromServer()
                }
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                    
                }
                else {

                }
                
            }) { (error) in
                print(error.debugDescription)
            }
        }
    }
    
}


extension FetchingData_VC {
    
    //MARK:
    //MARK: Fetch data from InvitationUpdates Loader
    func FetchInvitationUpdatesDataFromServer() {
        
        var is_API = false
        
        let param = [
            "AppVersion"               : "1.0.1",
            "ClientId"                 : loggedInUser.ClientId,
            "DeviceType"               : "1",
            "ClientPNID"               : AppManager.getDeviceToken(),
            "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            ServerManager.shared.httpPost(request: "\(API_INVITATIONUPDATE)", params: parameter, successHandler: { (JSON) in
             //   ServerManager.shared.hidHud()
                if is_API == false {
                    is_API = true
                    self.lbl_FetchingData.text = "Loading ......".localizedKey()
                    self.FetchPhoneActiviteDataFromServer()
                }
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                }
                
            }) { (error) in
                print(error.debugDescription)
            }
        }
    }
    
}


extension FetchingData_VC {
    
    //MARK:
    //MARK: Fetch data from Phone Activite Loader
    func FetchPhoneActiviteDataFromServer() {
        
        var is_API = false
        let param = [
            "AppVersion"               : "1.0.1",
            "ClientId"                 : loggedInUser.ClientId,
            "DeviceType"               : "1",
            "ClientPNID"               : AppManager.getDeviceToken(),
            "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            ServerManager.shared.httpPost(request: "\(API_PHONEACTIVATE)", params: parameter, successHandler: { (JSON) in
               // ServerManager.shared.hidHud()
                if is_API == false {
                    is_API = true
                    self.lbl_FetchingData.text = "Loading ......".localizedKey()
                    self.FetchPhoneConfirmDataFromServer()
                }
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                }
                
            }) { (error) in
                print(error.debugDescription)
            }
        }
    }
    
}

extension FetchingData_VC {
    
    //MARK:
    //MARK: Fetch data from Phone Confirm Loader
    func FetchPhoneConfirmDataFromServer() {
        
        var is_API = false
        let param = [
            "AppVersion"               : "1.0.1",
            "ClientId"                 : loggedInUser.ClientId,
            "DeviceType"               : "1",
            "ClientPNID"               : AppManager.getDeviceToken(),
            "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            ServerManager.shared.httpPost(request: "\(API_PHONECONFIRM)", params: parameter, successHandler: { (JSON) in
               // ServerManager.shared.hidHud()
                if is_API == false {
                    is_API = true
                    self.lbl_FetchingData.text = "Loading ......".localizedKey()
                    self.FetchTicketActionDataFromServer()
                }
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                }
            }) { (error) in
                print(error.debugDescription)
            }
        }
    }
    
}


extension FetchingData_VC {
    
    //MARK:
    //MARK: Fetch data from Ticket Action Loader
    func FetchTicketActionDataFromServer() {
        
        var is_API = false
        let param = [
            "AppVersion"               : "1.0.1",
            "ClientId"                 : loggedInUser.ClientId,
            "DeviceType"               : "1",
            "ClientPNID"               : AppManager.getDeviceToken(),
            "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            ServerManager.shared.httpPost(request: "\(API_TICKETACTION)", params: parameter, successHandler: { (JSON) in
               // ServerManager.shared.hidHud()
                
                if is_API == false {
                    is_API = true
                    self.lbl_FetchingData.text = "Loading ......".localizedKey()
                    self.FetchTicketUpdateDataFromServer()
                }
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                }
           
                
            }) { (error) in
                print(error.debugDescription)
            }
        }
    }
    
}


extension FetchingData_VC {
    
    //MARK:
    //MARK: Fetch data from Ticket Update Loader
    func FetchTicketUpdateDataFromServer() {
        
        let param = [
            "AppVersion"               : "1.0.1",
            "ClientId"                 : loggedInUser.ClientId,
            "DeviceType"               : "1",
            "ClientPNID"               : AppManager.getDeviceToken(),
            "DeviceId"                 : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))"
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            ServerManager.shared.httpPost(request: "\(API_TICKETUPDATE)", params: parameter, successHandler: { (JSON) in
               // ServerManager.shared.hidHud()
                
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                    
                    let loadingView = self.storyboard?.instantiateViewController(withIdentifier: "loadingView") as! LoadingView;
                    AppDelegate.sharedDelegate.switchToNewView(newViewController: loadingView, oldViewController: self);
                }
                else {

                    let loadingView = self.storyboard?.instantiateViewController(withIdentifier: "loadingView") as! LoadingView;
                    AppDelegate.sharedDelegate.switchToNewView(newViewController: loadingView, oldViewController: self);
                }
                
            }) { (error) in
                print(error.debugDescription)
                ServerManager.shared.hidHud()
            }
        }
    }
    
}



