//
//  AppDelegate.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 30/09/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseMessaging
import UserNotifications
import Fabric
import Crashlytics
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var navigation:       UINavigationController?
    var window:           UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
//        Fabric.with([Crashlytics.self])
        
        //Intialize google plus
        GIDSignIn.sharedInstance().clientID = "841928811498-8ha78ue9a3144rlg9upmll0ftn50sp7n.apps.googleusercontent.com"
        
       
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true
        
        let UUIDValue = UIDevice.current.identifierForVendor!.uuidString
        UserDefaults.SFSDefault(setValue: UUIDValue, forKey: kDeviceId)
        //Register Device For Push Notification
        self.setDeviceForPushNotification(application)
        application.applicationIconBadgeNumber = 0
        application.registerForRemoteNotifications()
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name("UserLoggedIn"), object: nil)
//
        //Intilize Facebook SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("options>>>\(options)")
        print("url>>>\(url)")
        if url.scheme!.hasPrefix("fb\(FBSDKSettings.appID())") {
            let handle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
            return handle
        }else{
            let handle = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
            return handle
        }
    }

    //MARK:
    //MARK: Custom Methods
    
    class var sharedDelegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func getViewControllerFromCustomer(viewControllerName identifier : String)->AnyObject{
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller:AnyObject = storyBoard.instantiateViewController(withIdentifier: identifier)as AnyObject
        return controller
    }
    
    func switchToNewView(newViewController : UIViewController, oldViewController : UIViewController){
        self.window?.rootViewController = newViewController;
        oldViewController.dismiss(animated: false, completion: nil);
    }
    
    //MARK:
    //MARK:Push Notification Delegate Methods
    @objc func userLoggedIn() {
        self.getFCMToken()
    }
    
    func getFCMToken() {
        if let refreshedToken = InstanceID.instanceID().token() {
            UserDefaults.standard.set(refreshedToken, forKey: kDeviceToken)
            print(UserDefaults.standard.value(forKey: kDeviceToken)!)
        }
    }

    func setDeviceForPushNotification(_ application : UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }
    
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data )
    {
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? Dictionary<String, Any> {
            self.didReceiveNotificationResponse(userInfo: userInfo, isBackground: true)
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo as NSDictionary //Dictionary<String, Any>gcm.notification.messageData
        print(userInfo)
       let dict = convertToDictionary(text: userInfo["messageData"] as! String)
        print(dict!)
        let apsData = userInfo["aps"] as! Dictionary<String, Any>
        print(apsData)
        let dic = apsData["alert"] as! NSDictionary
        let dic_Data = dict
        print(dic_Data!)
        let nc = NotificationCenter.default
        if dic.value(forKey: "title") as? String == "New ticket" {
      //  if apsData["messageType"] as! String == "0" {
            
          DBManager.getSharedInstance()?.saveAvTicketsData(
                               "\(dic_Data!["TicketId"]!)",
            ticketManualId:    "\(dic_Data!["TicketManualId"]!)",
            ticketType:        "\(dic_Data!["TicketTypeName"]!)",
            ticketAmount:      "1",
            eventName:         "\(dic_Data!["EventName"]!)",
            eventLocation:     "\(dic_Data!["EventLocation"]!)",
            eventStartDate:    "\(dic_Data!["EventStartDate"]!)",
            eventEndDate:      "\(dic_Data!["EventEndDate"]!)",
            eventCategory:     "\(dic_Data!["EventCategoryId"]!)",
            upGradeEnable:     "\(dic_Data!["UpgradeEnabled"]!)",
            chatEnabled:       "\(dic_Data!["ChatEnabled"]!)",
            rateEnabled:       "\(dic_Data!["RateEnabled"]!)",
            backgroundCode:    "\(dic_Data!["BackgroundCode"]!)",
            receivedDate:      "\(dic_Data!["RateEnabled"]!)",
            userDate:          "\(dic_Data!["SpecialValue"]!)",
            usedBy:            "",
            pinEntry:          "",
            usedSendDate:      "",
            usedSendLog:       "",
            date:              "26/11/2018")

            nc.post(name: Notification.Name("ticketUpdate"), object: nil)

            completionHandler([.alert])
        }
        else if dic.value(forKey: "title") as? String == "New Inviteation" {
          
            let arr_Invitations = ((DBManager.getSharedInstance()?.find(byAvInvites: "") )as! NSArray).mutableCopy() as! NSMutableArray
            
            if arr_Invitations.count > 0 {
                
                let id =  dic_Data!["InviteId"] as? String
                let indx = (arr_Invitations.value(forKey: "id") as! NSArray).index(of: id!)
                if indx < arr_Invitations.count {
                    let dicTemp = arr_Invitations[indx] as! NSDictionary
                   DBManager.getSharedInstance()?.updateInvitation("\(dicTemp.value(forKey: "id")!)", invitationAccepted: "\(dic_Data!["InviteAccepted"]!)")
                }
                else {
                    DBManager.getSharedInstance()?.saveAvInvitesData(
                        "\(dic_Data!["InviteId"]!)",
                        inviteTitle:       "\(dic_Data!["InviteTitle"]!)",
                        inviteLocation:    "\(dic_Data!["InviteLocation"]!)",
                        inviteDescription: "\(dic_Data!["InviteDescription"]!)",
                        inviteCategory:    "\(dic_Data!["InviteCategoryId"]!)",
                        inviteDate:        "\(dic_Data!["InviteDate"]!)",
                        inviteValidDate:   "\(dic_Data!["InviteExpireDate"]!)",
                        inviteBackground:  "\(dic_Data!["InviteBackgroundId"]!)",
                        inviteAccepted:    "\(dic_Data!["InviteAccepted"]!)",
                        date:              "26/11/2018")
                    completionHandler([.alert])
                }
            }
            else {
                DBManager.getSharedInstance()?.saveAvInvitesData(
                    dic_Data!["InviteId"] as? String,
                    inviteTitle:       "\(dic_Data!["InviteTitle"]!)",
                    inviteLocation:    "\(dic_Data!["InviteLocation"]!)",
                    inviteDescription: "\(dic_Data!["InviteDescription"]!)",
                    inviteCategory:    "\(dic_Data!["InviteCategoryId"]!)",
                    inviteDate:        "\(dic_Data!["InviteDate"]!)",
                    inviteValidDate:   "\(dic_Data!["InviteExpireDate"]!)",
                    inviteBackground:  "\(dic_Data!["InviteBackgroundId"]!)",
                    inviteAccepted:    "\(dic_Data!["InviteAccepted"]!)",
                    date:              "26/11/2018")
                completionHandler([.alert])
            }
            
            nc.post(name: Notification.Name("invitationUpdate"), object: nil)

        }
        else{
            completionHandler([.alert])
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
        UserDefaults.SFSDefault(setObject: "", forKey: kDeviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
        if application.applicationState == .active {
            self.didReceiveNotificationResponse(userInfo: userInfo as! Dictionary<String, Any>, isBackground: false)
        }else{
            self.didReceiveNotificationResponse(userInfo: userInfo as! Dictionary<String, Any>, isBackground: true)
        }
    }
    
    
    func didReceiveNotificationResponse(userInfo : Dictionary<String, Any> , isBackground: Bool){
        
        let apsData = userInfo["aps"] as! Dictionary<String, Any>
        let dic = apsData["alert"] as! NSDictionary
        let dict = convertToDictionary(text: userInfo["messageData"] as! String)
        print(dict!)
        let dic_Data = dict
        let nc = NotificationCenter.default
        if dic.value(forKey: "title") as? String == "New ticket" {
            //  if apsData["messageType"] as! String == "0" {
            
            DBManager.getSharedInstance()?.saveAvTicketsData(
                "\(dic_Data!["TicketId"]!)",
                ticketManualId:    "\(dic_Data!["TicketManualId"]!)",
                ticketType:        "\(dic_Data!["TicketTypeName"]!)",
                ticketAmount:      "1",
                eventName:         "\(dic_Data!["EventName"]!)",
                eventLocation:     "\(dic_Data!["EventLocation"]!)",
                eventStartDate:    "\(dic_Data!["EventStartDate"]!)",
                eventEndDate:      "\(dic_Data!["EventEndDate"]!)",
                eventCategory:     "\(dic_Data!["EventCategoryId"]!)",
                upGradeEnable:     "\(dic_Data!["UpgradeEnabled"]!)",
                chatEnabled:       "\(dic_Data!["ChatEnabled"]!)",
                rateEnabled:       "\(dic_Data!["RateEnabled"]!)",
                backgroundCode:    "\(dic_Data!["BackgroundCode"]!)",
                receivedDate:      "\(dic_Data!["RateEnabled"]!)",
                userDate:          "\(dic_Data!["SpecialValue"]!)",
                usedBy:            "",
                pinEntry:          "",
                usedSendDate:      "",
                usedSendLog:       "",
                date:              "26/11/2018")
            
            nc.post(name: Notification.Name("ticketUpdate"), object: nil)
            
        }
        else if dic.value(forKey: "title") as? String == "New Inviteation" {
            
            let arr_Invitations = ((DBManager.getSharedInstance()?.find(byAvInvites: "") )as! NSArray).mutableCopy() as! NSMutableArray
            
            if arr_Invitations.count > 0
            {
                let id =  dic_Data!["InviteId"] as? String
                let indx = (arr_Invitations.value(forKey: "id") as! NSArray).index(of: id!)
                if indx < arr_Invitations.count {
                    
                    let dicTemp = arr_Invitations[indx] as! NSDictionary
                    DBManager.getSharedInstance()?.updateInvitation("\(dicTemp.value(forKey: "id")!)", invitationAccepted: "\(dic_Data!["InviteAccepted"]!)")
                }
                else {
                    DBManager.getSharedInstance()?.saveAvInvitesData(
                        "\(dic_Data!["InviteId"]!)",
                        inviteTitle:       "\(dic_Data!["InviteTitle"]!)",
                        inviteLocation:    "\(dic_Data!["InviteLocation"]!)",
                        inviteDescription: "\(dic_Data!["InviteDescription"]!)",
                        inviteCategory:    "\(dic_Data!["InviteCategoryId"]!)",
                        inviteDate:        "\(dic_Data!["InviteDate"]!)",
                        inviteValidDate:   "\(dic_Data!["InviteExpireDate"]!)",
                        inviteBackground:  "\(dic_Data!["InviteBackgroundId"]!)",
                        inviteAccepted:    "\(dic_Data!["InviteAccepted"]!)",
                        date:              "26/11/2018")
                }
            }
            else {
                DBManager.getSharedInstance()?.saveAvInvitesData(
                    dic_Data!["InviteId"] as? String,
                    inviteTitle:       "\(dic_Data!["InviteTitle"]!)",
                    inviteLocation:    "\(dic_Data!["InviteLocation"]!)",
                    inviteDescription: "\(dic_Data!["InviteDescription"]!)",
                    inviteCategory:    "\(dic_Data!["InviteCategoryId"]!)",
                    inviteDate:        "\(dic_Data!["InviteDate"]!)",
                    inviteValidDate:   "\(dic_Data!["InviteExpireDate"]!)",
                    inviteBackground:  "\(dic_Data!["InviteBackgroundId"]!)",
                    inviteAccepted:    "\(dic_Data!["InviteAccepted"]!)",
                    date:              "26/11/2018")
            }
            
            nc.post(name: Notification.Name("invitationUpdate"), object: nil)
            
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.noData)
    }

}
