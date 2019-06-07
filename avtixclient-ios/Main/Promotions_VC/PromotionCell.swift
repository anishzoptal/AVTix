//
//  PromotionCell.swift
//  avtixclient-ios
//
//  Created by eshan Cheema on 06/12/18.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class PromotionCell: UITableViewCell {

    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Detail: UILabel!
    @IBOutlet weak var Btn_Ticket: UIButton!
    @IBOutlet weak var img_BgView: UIImageView!
    var link = "";
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buyticket(_ sender: Any) {
        let url = NSURL(string: link)! as URL;
        UIApplication.shared.open(url, options: [:], completionHandler: nil);
    }
}
