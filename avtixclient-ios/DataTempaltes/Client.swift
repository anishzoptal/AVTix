//
//  Client.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 19/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit;

class Client {
    var clientID : String = "Default Client ID";
    var deviceID : String = "Default Device ID";
    var deviceType : DeviceType = DeviceType.iOS;
    var appVersion : String = "Default App version";
    
    init(){
        deviceID = UIDevice.current.identifierForVendor!.uuidString;
        appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String;
    }
}
