//
//  ProfileViewControlelr.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 14/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: SlideInMenuManager {
    
    @IBOutlet var dimmerView: UIView!
    @IBOutlet var slideInView: UIView!
    @IBOutlet var profileScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeView = ActiveView.PROFILE
        _dimmer = dimmerView
        slideMenuContainer = slideInView
        setUpSlideMenu()
        setUpScrollView()
        NotificationCenter.default.addObserver(self, selector: #selector(methodOFReceivedNotication(notification:)) , name:NSNotification.Name(rawValue: "NotificationIdentifier"), object: nil)
    }
    
    func setUpScrollView(){
        
        let profileView = Bundle.main.loadNibNamed("ProfileData", owner: self, options: nil)?.first as! ProfileDataController;
        profileView.profileViewController = self;
        profileScrollView.contentSize.height = profileView.frame.height;
        profileScrollView.addSubview(profileView);
        profileView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: profileView.frame.height);
        profileScrollView.layoutIfNeeded();
        profileView.layoutIfNeeded();
        profileView.setUpProfileView();
    }
    
    @objc func methodOFReceivedNotication(notification: NSNotification){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNumber_VC") as! PhoneNumber_VC
        self.navigationController?.pushViewController(vc, animated: true)
//        self.performSegue(withIdentifier: "PhoneNumber", sender: self)
    }
    
}
