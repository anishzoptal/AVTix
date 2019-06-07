//
//  User.swift
//  Utradia
//
//  Created by Manpreet Kaur on 15/06/18.
//  Copyright © 2018 Vibrant appz All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject , NSCoding {
    
    var ClientId             = String()
    var ClientFirstName      = String()
    var ClientLastName       = String()
    var ClientPhoneActivated = String()
    var ClientDisplayName    = String()
    var ClientCountryCode    = String()
    var ClientCode           = String()
    var ClientPNID           = String()
    var ClientEmailAddress   = String()
    var ClientPhoneNumber    = String()
    
    override init() {
        
    }
    
    init(userData:JSON) {
        self.ClientId                       = userData["ClientId"].stringValue
        self.ClientFirstName                = userData["ClientFirstName"].stringValue
        self.ClientLastName                 = userData["ClientLastName"].stringValue
        self.ClientPhoneActivated           = userData["ClientPhoneActivated"].stringValue
        self.ClientDisplayName              = userData["ClientDisplayName"].stringValue
        self.ClientCountryCode              = userData["ClientCountryCode"].stringValue
        self.ClientCode                     = userData["ClientCode"].stringValue
        self.ClientPNID                     = userData["ClientPNID"].stringValue
        self.ClientEmailAddress             = userData["ClientEmailAddress"].stringValue
        self.ClientPhoneNumber              = userData["ClientPhoneNumber"].stringValue
    }
    
    init(user_Data:JSON) {
        self.ClientId                       = user_Data["ClientId"].stringValue
        self.ClientFirstName                = user_Data["ClientFirstName"].stringValue
        self.ClientLastName                 = user_Data["ClientLastName"].stringValue
        self.ClientPhoneActivated           = user_Data["ClientPhoneActivated"].stringValue
        self.ClientDisplayName              = user_Data["ClientDisplayName"].stringValue
        self.ClientCountryCode              = user_Data["ClientCountryCode"].stringValue
        self.ClientCode                     = user_Data["ClientCode"].stringValue
        self.ClientPNID                     = user_Data["ClientPNID"].stringValue
        self.ClientEmailAddress             = user_Data["ClientEmailAddress"].stringValue
        self.ClientPhoneNumber              = user_Data["ClientPhoneNumber"].stringValue
        
    }
    
    // MARK: NSCoding Protocol
    required public init(coder aDecoder: NSCoder) {
        
        self.ClientId             = aDecoder.decodeObject(forKey: "ClientId") as! String
        self.ClientFirstName      = aDecoder.decodeObject(forKey: "ClientFirstName") as! String
        self.ClientLastName       = aDecoder.decodeObject(forKey: "ClientLastName") as! String
        self.ClientPhoneActivated = aDecoder.decodeObject(forKey: "ClientPhoneActivated") as! String
        self.ClientDisplayName    = aDecoder.decodeObject(forKey: "ClientDisplayName") as! String
        self.ClientCountryCode    = aDecoder.decodeObject(forKey: "ClientCountryCode") as! String
        self.ClientCode           = aDecoder.decodeObject(forKey: "ClientCode") as! String
        self.ClientPNID           = aDecoder.decodeObject(forKey: "ClientPNID") as! String
        self.ClientEmailAddress   = aDecoder.decodeObject(forKey: "ClientEmailAddress") as! String
        self.ClientPhoneNumber    = aDecoder.decodeObject(forKey: "ClientPhoneNumber") as! String
       //
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.ClientId,             forKey: "ClientId")
        aCoder.encode(self.ClientFirstName,      forKey: "ClientFirstName")
        aCoder.encode(self.ClientLastName,       forKey: "ClientLastName")
        aCoder.encode(self.ClientPhoneActivated, forKey: "ClientPhoneActivated")
        aCoder.encode(self.ClientDisplayName,    forKey: "ClientDisplayName")
        aCoder.encode(self.ClientCountryCode,    forKey: "ClientCountryCode")
        aCoder.encode(self.ClientCode,           forKey: "ClientCode")
        aCoder.encode(self.ClientPNID,           forKey: "ClientPNID")
        aCoder.encode(self.ClientEmailAddress,   forKey: "ClientEmailAddress")
        aCoder.encode(self.ClientPhoneNumber,    forKey: "ClientPhoneNumber")
        
    }
}

