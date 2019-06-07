//
//  GlobalData.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 31/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation

class Global{
    static let data = Global();
    
    //Globally available data
    var profile : Profile!;
    var client : Client!;
    var tickets : [Ticket]!;
    
}
