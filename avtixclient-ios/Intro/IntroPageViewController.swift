//
//  PageViewController.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 30/09/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

class IntroPageViewController: UIPageViewController {
    
    var introPages : [UIViewController] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        moveToLoginVC()
    }
    
    func moveToLoginVC(){
        if AppManager.isLogin() {
            let loadingView = self.storyboard?.instantiateViewController(withIdentifier: "FetchingData_VC") as! FetchingData_VC
            AppDelegate.sharedDelegate.switchToNewView(newViewController: loadingView, oldViewController: self);
        }
        else {
             SetUpPages();
        }
      
    }
    
    func SetUpPages(){
        GetPages();
//        dataSource = self;
        if let firstPage = introPages.first{
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil);
        }
    }
    
    func GetPages(){
        let page4 = storyboard?.instantiateViewController(withIdentifier: "intro_page_4");
        introPages.append(page4!);
    }
}
