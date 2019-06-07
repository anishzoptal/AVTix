//
//  EventCell.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 03/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var eventName: UILabel!
    @IBOutlet var eventLocation: UILabel!
    @IBOutlet var eventDescription: UILabel!
    
    var link = "";
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBAction func buyticket(_ sender: Any) {
        let url = NSURL(string: link)! as URL;
        UIApplication.shared.open(url, options: [:], completionHandler: nil);
    }
    
}
