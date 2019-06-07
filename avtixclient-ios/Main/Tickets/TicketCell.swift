//
//  TicketCell.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 09/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class TicketCell: UICollectionViewCell{
    
    @IBOutlet weak var img_Photo: UIImageView!
    @IBOutlet weak var lbl_Used: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var dateTime: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var amount: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var eventName: UILabel!
    
    var ticketData : Ticket!;
    var controller : TicketsViewController!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUpTicket(){
        if(ticketData.backgroundImage != nil){
            backgroundImage.image = ticketData.backgroundImage;
        }
        else {
            //use once actual data is available
            //print("Error: ticket has no background, default (blank) is used");
        }
        type.text = ticketData.type;
        amount.text = String(ticketData.amount);
        location.text = ticketData.location;
        eventName.text = ticketData.eventName;
    }
    
    @IBAction func openTicket(_ sender: Any) {
//        controller.openTicket(ticketData: ticketData);
    }
}
