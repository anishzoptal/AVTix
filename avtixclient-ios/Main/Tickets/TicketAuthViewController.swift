//
//  TicketAuthViewController.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 31/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class TicketAuthViewController: UIViewController {
    
   // var ticketData : Ticket!;
    var str_TicketId = ""
    @IBOutlet weak var btn:   UIButton!
    @IBOutlet weak var btn_0: UIButton!
    @IBOutlet weak var btn_1: UIButton!
    @IBOutlet weak var btn_2: UIButton!
    @IBOutlet weak var btn_3: UIButton!
    @IBOutlet weak var btn_4: UIButton!
    @IBOutlet weak var btn_5: UIButton!
    @IBOutlet weak var btn_6: UIButton!
    @IBOutlet weak var btn_7: UIButton!
    @IBOutlet weak var btn_8: UIButton!
    @IBOutlet weak var btn_9: UIButton!
    
    @IBOutlet weak var view_Invalidated: UIView!
    
    var sender : SingleTicketController!;
    @IBOutlet var pinField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        btn.round(corners: .allCorners, radius: btn.frame.height / 2)
        btn_0.round(corners: .allCorners, radius: btn_0.frame.height / 2)
        btn_1.round(corners: .allCorners, radius: btn_1.frame.height / 2)
        btn_2.round(corners: .allCorners, radius: btn_2.frame.height / 2)
        btn_3.round(corners: .allCorners, radius: btn_3.frame.height / 2)
        btn_4.round(corners: .allCorners, radius: btn_4.frame.height / 2)
        btn_5.round(corners: .allCorners, radius: btn_5.frame.height / 2)
        btn_6.round(corners: .allCorners, radius: btn_6.frame.height / 2)
        btn_7.round(corners: .allCorners, radius: btn_7.frame.height / 2)
        btn_8.round(corners: .allCorners, radius: btn_8.frame.height / 2)
        btn_9.round(corners: .allCorners, radius: btn_9.frame.height / 2)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //sender.authLoaded = false;
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func validatePinPressed(_ sender: Any) {
        if(pinField.text!.count >= 6){
            performSegue(withIdentifier: "ticketAuthCode", sender: self);
        }
    }
    
    @IBAction func ProceedBtnAction(_ sender: Any) {
        view_Invalidated.isHidden = true
    }
    @IBAction func ExitBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func numberPressed(_ sender: UIButton) {
        if(pinField.text!.count < 10){
            pinField.text!.append(sender.titleLabel!.text!);
        }
    }
    
    @IBAction func deleteKeyPressed(_ sender: Any) {
        if(pinField.text!.count > 0){
            pinField.text!.removeLast();
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let authConfirmation = segue.destination as! TicketAuthConfirmationViewController;
        authConfirmation.pin = pinField.text!;
        authConfirmation.str_TicketId = str_TicketId
    }
}
