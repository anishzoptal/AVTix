//
//  SldeInMenuController.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 07/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit
import Foundation

class SlideInMenuController: UIViewController {
    
    @IBOutlet weak var lbl_InvitationCount: UILabel!
    @IBOutlet weak var lbl_TicketCount: UILabel!
    var opened : Bool = false;
    var activeView = ActiveView.UNDEFINED;
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate;
    var arr_Tickets = NSArray()
    var arr_Invitations = NSArray()
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var profileEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        AppManager.getLoggedInUser()
        
         arr_Tickets = (DBManager.getSharedInstance()?.find(byAvTickets: "") )!
        arr_Invitations = (DBManager.getSharedInstance()?.find(byAvInvites: "") )!
        lbl_TicketCount.text = "\(arr_Tickets.count)"
        lbl_InvitationCount.text = "\(arr_Invitations.count)"
        profileName.text = loggedInUser.ClientDisplayName;
        profileEmail.text = loggedInUser.ClientEmailAddress;
        
        let nc1 = NotificationCenter.default
        nc1.addObserver(self, selector: #selector(invitationUpdate), name: Notification.Name("invitationUpdate"), object: nil)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(ticketUpdate), name: Notification.Name("ticketUpdate"), object: nil)
    }
    
    @objc func invitationUpdate() {
        arr_Invitations = (DBManager.getSharedInstance()?.find(byAvInvites: ""))!
        lbl_InvitationCount.text = "\(arr_Invitations.count)"
    }
    
    @objc func ticketUpdate() {
        arr_Tickets = (DBManager.getSharedInstance()?.find(byAvTickets: ""))!
        lbl_TicketCount.text = "\(arr_Tickets.count)"
    }
    @IBAction func homeButtonPressed(_ sender: Any) {
        if(activeView != ActiveView.HOME){
            let homeView = parent!.storyboard?.instantiateViewController(withIdentifier: "mainNavigationView");
            appDelegate?.switchToNewView(newViewController: homeView!, oldViewController: parent!.parent!);
        }else{
            (self.parent as! SlideInMenuManager).toggleSlideInMenu(self);
        }
    }
    
    @IBAction func ticketsButtonPressed(_ sender: Any) {
        if(activeView != ActiveView.TICKETS){
            let ticketView = parent!.storyboard?.instantiateViewController(withIdentifier: "ticketsNavigationView");
            appDelegate?.switchToNewView(newViewController: ticketView!, oldViewController: parent!.parent!);
        }else{
            (self.parent as! SlideInMenuManager).toggleSlideInMenu(self);
        }
    }
    
    @IBAction func invitationsButtonPressed(_ sender: Any) {
        print("invitations");
        if(activeView != ActiveView.INVITATIONS){
            let ticketView = parent!.storyboard?.instantiateViewController(withIdentifier: "InivitationNavigationView");
            appDelegate?.switchToNewView(newViewController: ticketView!, oldViewController: parent!.parent!);
        }else{
            (self.parent as! SlideInMenuManager).toggleSlideInMenu(self);
        }
    }
    
    @IBAction func promotionsButtonPressed(_ sender: Any) {        
        if(activeView != ActiveView.PROMOTIONS){
            let ticketView = parent!.storyboard?.instantiateViewController(withIdentifier: "PromotionsNavigationView");
            appDelegate?.switchToNewView(newViewController: ticketView!, oldViewController: parent!.parent!);
        }else{
            (self.parent as! SlideInMenuManager).toggleSlideInMenu(self);
        }
    }
    
    @IBAction func profileButtonPressed(_ sender: Any) {
        if(activeView != ActiveView.PROFILE){
            let profileView = parent!.storyboard?.instantiateViewController(withIdentifier: "profileNavigationView");
            appDelegate?.switchToNewView(newViewController: profileView!, oldViewController: parent!.parent!);
        }else{
            (self.parent as! SlideInMenuManager).toggleSlideInMenu(self);
        }
    }
    
    @IBAction func aboutButtonPressed(_ sender: Any) {
        if(activeView != ActiveView.ABOUT){
            let aboutView = parent!.storyboard?.instantiateViewController(withIdentifier: "aboutNavigationView");
            appDelegate?.switchToNewView(newViewController: aboutView!, oldViewController: parent!.parent!);
        }else{
            (self.parent as! SlideInMenuManager).toggleSlideInMenu(self);
        }
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        let signOutView = parent!.storyboard?.instantiateViewController(withIdentifier: "signOutView");
        appDelegate?.switchToNewView(newViewController: signOutView!, oldViewController: parent!.parent!);
    }
}
