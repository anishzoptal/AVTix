//
//  Config.swift
//  
//
//  Created by Manpreet Kaur on 11/01/18.
//  Copyright © 2018 Vibrant appz All rights reserved.
//

import Foundation

#if DEBUG
    /************************
     //MARK:- DEBUG MODE
     *************************/
   let API_BASE_URL  =  "http://client.avtix.com"
    
#else
    /************************
     //MARK:- RELEASE MODE
     *************************/
    let API_BASE_URL  = "http://client.avtix.com"
    
#endif

//MARK: USER MANAGEMENT

let API_LOADTICKETS              = API_BASE_URL + "/Shared/LoadTickets.ashx"
let API_LOADINVITATIONS          = API_BASE_URL + "/Shared/LoadInvitations.ashx"
let API_LOADCATEGORIES           = API_BASE_URL + "/Shared/LoadCategories.ashx"
let API_LOADBACKGROUNDS          = API_BASE_URL + "/Shared/LoadBackgrounds.ashx"
let API_LOADEVENTS               = API_BASE_URL + "/Shared/LoadEvents.ashx"
let API_LOADPROMOTIONS           = API_BASE_URL + "/Shared/LoadPromotions.ashx"
let API_ACCOUNTRECOVER           = API_BASE_URL + "/Client/ClientAccountRecover.ashx"
let API_INVITATIONUPDATE         = API_BASE_URL + "/Client/ClientInvitationUpdate.ashx"
let API_LOGIN                    = API_BASE_URL + "/Client/ClientLogin.ashx"
let API_PHONEACTIVATE            = API_BASE_URL + "/Client/ClientPhoneActivate.ashx"
let API_PHONECONFIRM             = API_BASE_URL + "/Client/ClientPhoneConfirm.ashx"
let API_REGISTER                 = API_BASE_URL + "/Client/ClientRegister.ashx"
let API_TICKETACTION             = API_BASE_URL + "/Client/ClientTicketAction.ashx"
let API_TICKETUPDATE             = API_BASE_URL + "/Client/ClientTicketUpdate.ashx"
let API_CLIENTUPDATE             = API_BASE_URL + "/Client/ClientUpdate.ashx"
let API_PASSWORDCHANGE           = API_BASE_URL + "/Client/ClientPasswordChange.ashx"
let API_SOCIALMEDIALOGIN         = API_BASE_URL + "/Client/ClientLoginSocialMedia.ashx"
//


//MARK: CONSTANT VARIABLES

let kLanguage         = "language"
let kAlertTitle       = "AVTIXCLIENT"
let kDeviceType       = "ios"
let kDeviceId         = "deviceId"
let kDeviceToken      = "utredia_device_token"
let kUserID           = "utredia_user_id"
let kIsLogin          = "is_utredia_login"
let kAuthToken        = "authentication_token"
let kCurrentUser      = "currnetUser"
let kCurrentLatitude  = "currnetLatitude"
let kCurrentLongitude = "currnetLongitude"
let kCurrentAddress   = "currentAddress"
let kEmail            = "email"
let kUserName         = "username"
let kPassword         = "password"
let kIsUserBorrow     = "isUserBorrow"
let kAccessToken      = "accessToken"



let kUsernameValidation    = ".abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ "
let kZipCodeValidation     = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"
let kEmailCodeValidation   = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.@-"
let kPhoneNumberValidation = "+1234567890"
let kNumberValidation      = "1234567890"
let kGooglePlaceApiKey     = "AIzaSyCg-wWMm-h_y2u18izf0eD8oK60M8HJ508"

var loggedInUser: User!

//var objTabbar = Tabbar()

let kPasswordMaxLength    = 20
let kUserNameMaxLength    = 40
let kAgeMaxLength         = 3
let kZipCodeMaxLenght     = 10
let kCityMaxLength        = 30
let kPhoneNumberMaxLenght = 12
let kSubjectMaxLength     = 80
let kFeedbackMaxLenght    = 400
let kPriceMaxLenght       = 5
let kOffsetDefaultValue   = 10

var patientIdentityForAudioCall = String()

enum SearchControllerType : Int {
    case SC_Add    = 0
    case SC_Search = 1
    case SC_None
}

// MARK: Declaration for string constants to be used to notification.
public struct NotificationKeys {
    static let Refresh_Home_Screen_Data   = "refeshHomeScreenData"
    static let Move_To_Appointment_Detail = "moveToAppointmentDetails"

}

