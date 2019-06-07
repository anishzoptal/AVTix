//
//  LoadingView.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 02/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: UIViewController {
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate;
    @IBOutlet var loadingInformation: UILabel!
    var arr_AvBackgroundData = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        loadData();
       
      //  
        switchToMainView();
    }
    
    func loadData() {
        
    }
    
    func switchToMainView(){
        let mainNavigationView = storyboard?.instantiateViewController(withIdentifier: "mainNavigationView") as! MainNavigationController;
        appDelegate?.switchToNewView(newViewController: mainNavigationView, oldViewController: self);

    }
}
