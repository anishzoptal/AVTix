//
//  Login.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 19/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation

class Login {
    
    var _email : String!;
    var _pwd : String!;
    
    func attemptLogin(email: String, password: String) -> LoginResult {
        _email = email;
        _pwd = password;
        
        if(checkServerConnection() == "FAILED"){
            return LoginResult.SERVER_ERROR;
        }
        if(authenticateCredentials() == "FAILED"){
            return LoginResult.WRONG_CREDENTIALS;
        }
        if(getProfileData() == "FAILED"){
            return LoginResult.UNKNOWN;
        }
        
        return LoginResult.SUCCESS;
    }
    
    func checkServerConnection() -> String {
        //check for server connection and return the result
        return "OK";
    }
    
    func authenticateCredentials() -> String{
        //check if the credentials are correct
        return "OK";
    }
    
    func getProfileData() -> String {
        Global.data.profile = Profile();
        //fetch the profile from the database
        return "OK";
    }
    
}
