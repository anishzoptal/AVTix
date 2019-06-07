//
//  TicketData.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 13/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

struct Ticket {
    var ticketID : String! = "Default ID";
    var backgroundImage : UIImage!;
    var dateTime : Date! = Date();
    var type : String! = "Default Type";
    var amount : Int! = 0;
    var location : String! = "Default Location";
    var eventName : String! = "Default Event Name";
    var used : Bool! = false;
}
