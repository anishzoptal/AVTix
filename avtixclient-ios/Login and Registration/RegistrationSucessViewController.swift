//
//  RegistrationSucessViewController.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 28/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class RegistrationSucessViewController: UIViewController {

    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
    }

    @IBAction func startButtonPressed(_ sender: Any) {
        let loadingView = storyboard?.instantiateViewController(withIdentifier: "loadingView") as! LoadingView;
        appDelegate?.switchToNewView(newViewController: loadingView, oldViewController: self);
    }
}
