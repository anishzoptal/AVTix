//
//  SignOutViewController.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 16/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

class SignOutViewController : UIViewController {
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: kIsLogin)
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
      //  let navigationController:UINavigationController = storyBoard.instantiateInitialViewController() as! UINavigationController
        let vc = AppDelegate.sharedDelegate.getViewControllerFromCustomer(viewControllerName: "intro_page_signup") as! SignUpIntroPage
       // navigationController.viewControllers = [vc]
        AppDelegate.sharedDelegate.window?.rootViewController = vc
        AppDelegate.sharedDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func cancelSignOut(_ sender: Any) {
        let homeView = storyboard?.instantiateViewController(withIdentifier: "mainNavigationView");
        appDelegate?.switchToNewView(newViewController: homeView!, oldViewController: self);
    }
    
    @IBAction func closeApp(_ sender: Any) {
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil);
    }
}
