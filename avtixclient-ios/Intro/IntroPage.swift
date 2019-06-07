//
//  IntroPage.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 30/09/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

class IntroPage: UIViewController {
    
    @IBOutlet weak var lbl_Detail: UILabel!
    @IBOutlet weak var img_Icon: UIImageView!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet var btnContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img_Icon.round(corners: .allCorners, radius: img_Icon.frame.height / 2)
//        lbl_Detail.text = "Get tickets anywhere, anytime directly to\nyour SMART PHONE!\nOrganize your tickets, giftcards and\nvouchers the way you see it!\nGet feeds, news and gifts from all of\nyour popular ticketing sites!"
//        lbl_Detail.text = "\(lbl_Detail.text ?? "")".localizedKey()
//        btnContinue.setTitle("\(btnContinue.titleLabel?.text ?? "")".localizedKey(), for: .normal)
    }
    
    @IBAction func ContinueBtnAction(_ sender: Any) {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("UserLoggedIn"), object: nil)
        let signInView = storyboard?.instantiateViewController(withIdentifier: "intro_page_signup") as! SignUpIntroPage
        appDelegate?.switchToNewView(newViewController: signInView, oldViewController: self);
    }
}
