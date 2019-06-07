//
//  Profile.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 19/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit;

class Profile {
    var profileID : String = "Default Profile ID";
    var displayName : String = "Default Display Name";
    var firstName : String = "Default First Name";
    var lastName : String = "Default Last Name";
    var email : String = "defualt@email.com";
    var country : Country = Country();
    var phoneNumber : String = "099 123 4567";
    var picture : UIImage!;
}
