//
//  AboutRooViewController.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 15/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

class AboutRootViewController: SlideInMenuManager {
    
    @IBOutlet var dimmerView: UIView!
    @IBOutlet var slideInView: UIView!
    @IBOutlet var aboutScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        _dimmer = dimmerView;
        slideMenuContainer = slideInView;
        activeView = ActiveView.ABOUT;
        setUpSlideMenu();
        setUpScrollView();
    }
    
    func setUpScrollView(){
        let aboutData = Bundle.main.loadNibNamed("AboutData", owner: self, options: nil)?.first as! AboutData;
        aboutScrollView.addSubview(aboutData);
        aboutData.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: aboutData.frame.height);
        aboutScrollView.contentSize.height = aboutData.aboutDataContentSize();
        aboutScrollView.layoutIfNeeded();
        aboutData.layoutIfNeeded();
    }
    
    @IBAction func termsAndConditions(_ sender: Any) {
        performSegue(withIdentifier: "termsAndConditions", sender: self);
    }
    
    @IBAction func privacyPolicy(_ sender: Any) {
        performSegue(withIdentifier: "privacyPolicy", sender: self);
    }
}
