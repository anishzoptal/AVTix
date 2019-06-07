//
//  TicketAuthConfirmationViewController.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 09/11/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class TicketAuthConfirmationViewController: UIViewController {

    @IBOutlet var char_1: UIButton!
    @IBOutlet var char_2: UIButton!
    @IBOutlet var char_3: UIButton!
    var pin : String!
    var str_TicketId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        print(pin);
    }
    
    @IBAction func markUsedPressed(_ sender: Any) {
  //  let str_CurrentDate = AppManager.getCurrentDateString()
        DBManager.getSharedInstance()?.update(str_TicketId, pinEntry: "", userDate: "", usedBy: "1")
    DBManager.getSharedInstance()?.update("\(str_TicketId)", pinEntry: "\(pin!)", userDate: "", usedBy: "1")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func markUnusedPressed(_ sender: Any) {
    }
}
