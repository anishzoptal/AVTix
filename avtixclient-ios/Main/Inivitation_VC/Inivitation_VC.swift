//
//  Inivitation_VC.swift
//  avtixclient-ios
//
//  Created by eshan Cheema on 11/12/18.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class Inivitation_VC: SlideInMenuManager {

    @IBOutlet weak var table_View: UITableView!
    @IBOutlet var dimmerView:      UIView!
    @IBOutlet var slideMenuView:   UIView!
    @IBOutlet var noEventsView:    UIView!
    var arr_Invitations = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _dimmer = dimmerView;
        slideMenuContainer = slideMenuView;
        
        
        
        activeView = ActiveView.INVITATIONS;
        setUpSlideMenu();
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(invitationUpdate), name: Notification.Name("invitationUpdate"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arr_Invitations = (DBManager.getSharedInstance()?.find(byAvInvites: "") )!
    }
    
    @objc func invitationUpdate() {
        arr_Invitations = (DBManager.getSharedInstance()?.find(byAvInvites: "") )!
        table_View.reloadData()
    }
}

extension Inivitation_VC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableView Datasource  Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(arr_Invitations.count == 0){
            noEventsView.isHidden = false;
        }else{
            noEventsView.isHidden = true;
        }
        return arr_Invitations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! InvitationCell
        cell.selectionStyle = .none
        
        let dic = arr_Invitations.object(at: indexPath.row) as! NSDictionary
        //name fromDate  toDate
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold("\(dic.value(forKey: "title")!)\n", size: 18)
            .normal("\(dic.value(forKey: "description")!) ", size: 14)
      
        cell.lbl_UserName.text = "\(dic.value(forKey: "title")!)"
        cell.lbl_Address.text = "\(dic.value(forKey: "location")!)"
      
        let str_StartDate = AppManager.getFormatedDateFromString(currentdate: "\(dic.value(forKey: "valid")!)")
        cell.lbl_Date.text = str_StartDate
        let str_TimeDate = AppManager.getFormatedTimeFromString(currentdate: "\(dic.value(forKey: "valid")!)")
        cell.lbl_Time.text = str_TimeDate
        return cell
    }
    
    
    //MARK: UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = arr_Invitations.object(at: indexPath.row) as! NSDictionary
        if dic.value(forKey: "accepted") as! String == "1"{
         //   AppManager.showErrorDialog(viewControler: self, message: "This invitation is already Accepted.")
        }
        else if dic.value(forKey: "accepted") as! String == "0" {
          //  AppManager.showErrorDialog(viewControler: self, message: "This invitation is already Rejected.")
        }
        else {
            let vc = AppDelegate.sharedDelegate.getViewControllerFromCustomer(viewControllerName: "InvitationDetail_VC") as! InvitationDetail_VC
            vc.dic_Invitation = dic
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 171
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 171//UITableView.automaticDimension
    }
    
}

