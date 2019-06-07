//
//  InvitationCell.swift
//  avtixclient-ios
//
//  Created by eshan Cheema on 11/12/18.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class InvitationCell: UITableViewCell {

    @IBOutlet weak var lbl_Invitations: UILabel!
    @IBOutlet weak var lbl_Time: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_Address: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var Img_Background: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
