//
//  Register.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 28/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

class Register {
    
    var _displayName : String!;
    var _email : String!;
    var _pwd1 : String!;
    var _pwd2 : String!;
    
    func register(displayName : String, email : String, password1 : String, password2 : String) -> RegistrationResult {
        _displayName = displayName;
        _email = email;
        _pwd1 = password1;
        _pwd2 = password2;
        
        if(checkServerConnection() == "FAILED"){
            return RegistrationResult.SERVER_ERROR;
        }
        if(checkForExistingAccount() == "EXISTS"){
            return RegistrationResult.ACCOUNT_EXISTS;
        }
        if(registerInDatabase() == "FAILED"){
            return RegistrationResult.UNKNOWN;
        }
        return RegistrationResult.SUCCESS;
    }
    
    func checkServerConnection() -> String {
        //check for the server connection and return the result
        return "OK";
    }
    
    func checkForExistingAccount() -> String {
        //check if the account already exists
        return "OK";
    }
    
    func registerInDatabase() -> String {
        Global.data.profile = Profile();
        Global.data.profile.displayName = _displayName;
        Global.data.profile.email = _email;
        //write the new account to the database
        return "OK";
    }
}
