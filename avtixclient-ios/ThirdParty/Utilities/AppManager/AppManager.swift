//
//  AppManager.swift
//  
//
//  Created by Manpreet Kaur on 11/01/18.
//  Copyright © 2018 Vibrant appz All rights reserved.
//

import Foundation
import UIKit


class AppManager: NSObject {
    //MARK: App Manager Shared Instance
    class var shareInstance:AppManager {
        struct Singleton {
            static let instance = AppManager()
        }
        return Singleton.instance
    }
    
    //MARK: Show Error View
    
    func showView(inView: UIView,showMessage:String) {
        let alertview = UIView.init()
        //        let screenSize = UIScreen.main.bounds.width
        alertview.frame = CGRect.init(x: 0, y: 64, width: inView.frame.size.width, height: inView.frame.size.height )
        alertview.backgroundColor = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1.0)
        let messageImage = UIImageView.init(image: #imageLiteral(resourceName: "vip_zone_icon"))
        messageImage.frame = CGRect.init(x: (alertview.frame.size.width-70)/2, y: (alertview.frame.size.height/2)-100, width: 70, height: 70)
        let messageLabel = UILabel.init()
        messageLabel.frame = CGRect.init(x: Int(alertview.frame.origin.x+20), y: (Int(messageImage.frame.origin.y+messageImage.frame.size.height+20.0)), width: (Int(alertview.frame.size.width-40.0)), height: 200)
        messageLabel.backgroundColor = UIColor.black
        messageLabel.numberOfLines = 4
        messageLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        messageLabel.sizeToFit()
        messageLabel.textAlignment = .center
        messageLabel.text = showMessage
        alertview.addSubview(messageImage)
        alertview.addSubview(messageLabel)
        inView.addSubview(alertview)
    }
    
    
    
    //MARK: Shake textfield/textview
    func shakeTextField(textField: UITextField, withText:String, currentText:String) -> Void {
        textField.text = ""
        textField.attributedPlaceholder = NSAttributedString(string: currentText,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let isSecured = textField.isSecureTextEntry
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.10
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint:CGPoint.init(x: textField.center.x - 10, y: textField.center.y) )
        animation.toValue = NSValue(cgPoint: CGPoint.init(x: textField.center.x + 10, y: textField.center.y) )
        textField.layer.add(animation, forKey: "position")
        if isSecured {
            textField.isSecureTextEntry = false
        }
        textField.attributedPlaceholder = NSAttributedString(string: withText,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            textField.attributedPlaceholder = NSAttributedString(string: currentText,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            //  textField.placeholder = placeholder
            if isSecured {
                textField.isSecureTextEntry = true
            }
        }
        
    }
    
    
    func shakeTextView(textView: UITextView
        , withText:String, currentText:String) -> Void {
        textView.text = currentText
        textView.textColor =  UIColor.darkText
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.10
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint:CGPoint.init(x: textView.center.x - 10, y: textView.center.y) )
        animation.toValue = NSValue(cgPoint: CGPoint.init(x: textView.center.x + 10, y: textView.center.y) )
        textView.layer.add(animation, forKey: "position")
        textView.text = withText
        textView.textColor =  UIColor.red
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            textView.text = currentText
            textView.textColor = UIColor.darkText
            //  textField.placeholder = placeholder
        }
        
    }
    
    func shakeButton(button: UIButton){
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.10
        shake.repeatCount = 2
        shake.autoreverses = true
        let from_point:CGPoint = CGPoint.init(x: button.center.x - 10, y: button.center.y )
        let from_value:NSValue = NSValue(cgPoint: from_point)
        let to_point:CGPoint = CGPoint.init(x: button.center.x + 10, y: button.center.y )
        let to_value:NSValue = NSValue(cgPoint: to_point)
        shake.fromValue = from_value
        shake.toValue = to_value
        button.layer.add(shake, forKey: "position")
    }
    
    class func setSubViewlayout(_ subView: UIView , mainView : UIView){
        subView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addConstraint(NSLayoutConstraint(item: subView, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 0.0))
        
        mainView.addConstraint(NSLayoutConstraint(item: subView, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        
        mainView.addConstraint(NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        mainView.addConstraint(NSLayoutConstraint(item: subView, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
    }
    
    
    
    //MARK: Login/Sign Up Validations
    
    //  E-mail checking
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    //   Phone Number validation
    func validatePhoneNumber(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    //WhiteSpace Validation
    func containsWhiteSpace(textField: UITextField) -> Bool {
        if !(textField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            // string contains non-whitespace characters
            return false
        }
        return true
    }
    
    class func checkMaxLength(textField: UITextField!, maxLength: Int , range : NSRange) -> Bool {
        if (textField.text?.count)! >= maxLength && range.length == 0 {
            return false
        }else {
            return true
        }
    }
    
    //MARK:- GET USERID
    
    class func isLogin() -> Bool {
        return UserDefaults.SFSDefault(boolForKey: kIsLogin) ? true:false
    }
    
   
    class func getUserID() -> String {
        return UserDefaults.standard.object(forKey: kUserID) as? String ?? ""
        
    }
    
    class func saveLoggedInUser(currentUser: User) {
        let userData = NSKeyedArchiver.archivedData(withRootObject: currentUser)
        UserDefaults.SFSDefault(setObject: userData, forKey: kCurrentUser)
    }
    
    class func getLoggedInUser() {
        if AppManager.isLogin() {
            if let user = UserDefaults.standard.object(forKey: kCurrentUser) as? Data {
                if let userData = NSKeyedUnarchiver.unarchiveObject(with: user) as? User {
                    loggedInUser = User.init()
                    loggedInUser = userData
                }
            }
        }
    }
    
    
    
    class func getLanguage() -> String {
        if let language = UserDefaults.standard.value(forKey: "language") as? String {
            return language
        }else{
            return "en"
        }
    }
    
    class func getDeviceToken() -> String {
        if let deviceToken = UserDefaults.standard.value(forKey: kDeviceToken) as? String {
            if deviceToken.count > 0 {
                return deviceToken
            }
            else{
                return ""
            }
        }else{
            return ""
        }
    }
    
    class func getErrorMessage(_ error : Error) -> String {
        var errorMessage: NSString = NSString()
        switch error._code {
        case -998:
            errorMessage = "Unknow Error";
            break;
        case -1000:
            errorMessage = "Bad URL request";
            break;
        case -1001:
            errorMessage = "The request time out";
            break;
        case -1002:
            errorMessage = "Unsupported URL";
            break;
        case -1003:
            errorMessage = "The host could not be found";
            break;
        case -1004:
            errorMessage = "The host could not be connect, Please try after some time";
            break;
        case -1005:
            errorMessage = "The network connection lost, Please try agian";
            break;
        case -1009:
            errorMessage = "The internet connection appear to be  offline";
            break;
        case -1103:
            errorMessage = "Data lenght exceed to maximum defined data";
            break;
        case -1100:
            errorMessage = "File does not exist";
            break;
        case -1013:
            errorMessage = "User authentication required";
            break;
        case -2102:
            errorMessage = "The request time out";
            break;
            
        default:
            errorMessage = "Server Error";
            break;
        }
        return errorMessage as String
        
    }
    
    class func showErrorDialog(viewControler : UIViewController , message : String) {
        _ = UIAlertController.showAlertInViewController(viewController: viewControler, withTitle: "Avtixclient", message: message, cancelButtonTitle: NSLocalizedString("ok", comment: ""), destructiveButtonTitle: nil, otherButtonTitles: nil) { (controller, action , buttonIndex) in
        }
        
    }
    
    func localize(with string:String) -> String {
       let strKey = string.removeWhitespace().lowercased()
        print("localization ==> \(strKey) = \(string)")
        let value = NSLocalizedString(strKey, comment: "")
        return value
    }
    
    class func dayNameFromID(dayID : Int) -> String {
        switch dayID {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    }
    
    class func getTimeZone() -> String {
        let timeZone = TimeZone.current
        let name = timeZone.identifier
        if name.count > 0 {
            return name
        }else{
            return ""
        }
        
    }
    
    
    
    func resizeImage(image : UIImage , targetSize : CGSize) -> UIImage{
        let originalSize:CGSize =  image.size
        
        let widthRatio :CGFloat = targetSize.width/originalSize.width
        let heightRatio :CGFloat = targetSize.height/originalSize.height
        
        var newSize : CGSize!
        if widthRatio > heightRatio {
            newSize =  CGSize(width : originalSize.width*heightRatio ,  height : originalSize.height * heightRatio)
        }
        else{
            newSize = CGSize(width : originalSize.width * widthRatio , height : originalSize.height*widthRatio)
        }
        
        // preparing rect for new image
        
        let rect:CGRect =  CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        image .draw(in: rect)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
//    class func getCountryDialingCode() -> String  {
//        var arrayCountry = [Country]()
//        //Getting Path of Plist
//        let pathOfPlist = Bundle.main.path(forResource: "DiallingCodes", ofType: "plist")
//        //fetching Vlaues from Plist
//        if let dic = NSDictionary(contentsOfFile: pathOfPlist!) as? [String: Any] {
//            let arrayDialingCode = [Any] (dic.values) as NSArray
//            let arrayCountryCode = [String] (dic.keys) as NSArray
//            
//            //Generate country data dictionary
//            for i in 0..<arrayCountryCode.count{
//                let countryObj = Country()
//                countryObj.countryDialingCode = "+\(arrayDialingCode[i] as! String)"
//                countryObj.contryCode = arrayCountryCode[i] as! String
//                let currentLocale : NSLocale = NSLocale.init(localeIdentifier :  NSLocale.current.identifier)
//                let countryName : String? = currentLocale.displayName(forKey: NSLocale.Key.countryCode, value: arrayCountryCode[i])
//                if countryName?.count == 0 {
//                    countryObj.countryName = arrayCountryCode[i] as! String
//                    
//                }else{
//                    countryObj.countryName  = countryName!
//                    
//                }
//                arrayCountry.append(countryObj)
//                
//            }
//            var tempArray = [Country]()
//            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//                let name = AppManager.shareInstance.countryName(from: countryCode)
//                tempArray = name.isEmpty ? arrayCountry : arrayCountry.filter({(objCity: Country) -> Bool in
//                    if objCity.countryName.lowercased() == name.lowercased(){
//                        return true
//                    }else{
//                        return false
//                    }
//                })
//                if tempArray.count == 0 {
//                    return "+7"
//                }else{
//                    let obj = tempArray.first
//                    return (obj?.countryDialingCode)!
//                }
//            }else{
//                return "+7"
//            }
//        }
//        
//        return "+7"
//        
//    }
    
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return countryCode
        }
    }
    
    
    //MARK: Time Methods
    
    class func convertTime24HoursTo12Hours(dateAsString: String) -> String{
        if dateAsString.count == 0 {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        if date == nil {
            return dateAsString
        }
        let Date12 = dateFormatter.string(from: date!)
        print("12 hour formatted Date:",Date12)
        return Date12
    }
    
    class func convertTime12HoursTo24Hours(dateAsString: String) -> String {
        if dateAsString.count == 0 {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "h:mm a"
        
        let date = dateFormatter.date(from: dateAsString)
        if date == nil {
            return dateAsString
        }
        dateFormatter.dateFormat = "HH:mm"
        let Date24 = dateFormatter.string(from: date!)
        print("24 hour formatted Date:",Date24)
        return Date24
    }
    
    class func currentTime() -> String {
        //Convert time in UTC to Local TimeZone
        let outputTimeZone = NSTimeZone.local
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        outputDateFormatter.timeZone = outputTimeZone
        outputDateFormatter.dateFormat = "hh:mm a dd MMMM, yyyy"
        let currentData = Date()
        let outputString = outputDateFormatter.string(from: currentData)
        return outputString
    }
    
    class func convertTimeStampLocalTimeZone(timeStamp : Double) -> String {
        if timeStamp > 0 {
            let timeInterval: TimeInterval = TimeInterval.init(timeStamp)
            let date = NSDate(timeIntervalSince1970: timeInterval)
            //Convert time in UTC to Local TimeZone
            let outputTimeZone = NSTimeZone.local
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
            outputDateFormatter.timeZone = outputTimeZone
            outputDateFormatter.dateFormat = "hh:mm a"
            let outputString = outputDateFormatter.string(from: date as Date)
            return outputString
        }else{
            return AppManager.currentTime()
        }
        
        
    }

    class func convertDateStampLocalTimeZone(timeStamp : Double) -> String {
        if timeStamp > 0 {
            let timeInterval: TimeInterval = TimeInterval.init(timeStamp)
            let date = NSDate(timeIntervalSince1970: timeInterval)
            let outputTimeZone = NSTimeZone.local
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
            outputDateFormatter.timeZone = outputTimeZone
            outputDateFormatter.dateFormat = "EEEE, MMM d, yyyy"
            
            let outputString = outputDateFormatter.string(from: date as Date)
            return outputString
        }else{
            return AppManager.currentTime()
        }
    }
    
    
    class func convertDateTimeStampLocalTimeZone(timeStamp : Double) -> String {
        if timeStamp > 0 {
            let timeInterval: TimeInterval = TimeInterval.init(timeStamp)
            let date = NSDate(timeIntervalSince1970: timeInterval)
            let outputTimeZone = NSTimeZone.local
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
            outputDateFormatter.timeZone = outputTimeZone
            let locale = NSLocale.current
            let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!
            if formatter.contains("a") {
                outputDateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
                
                //phone is set to 12 hours
            } else {
                //phone is set to 24 hours
                outputDateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                
            }
            let outputString = outputDateFormatter.string(from: date as Date)
           
            return outputString
            
        }else{
            return AppManager.currentTime()
        }
    }
    
    
    class func checkEndTime(startTime: String , endTime: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        let startDate = dateFormatter.date(from: startTime)
        let endDate = dateFormatter.date(from: endTime)
        
        if startDate != nil && endDate != nil {
            print("start date - \(startDate!)")
            print("end date - \(endDate!)")
            let order = Calendar.current.compare(startDate!, to: endDate!, toGranularity: .minute)
            switch order {
            case .orderedAscending:
                print("\(endDate!) is after \(startDate!)")
                return true
            case .orderedDescending:
                print("\(endDate!) is before \(startDate!)")
            default:
                print("\(endDate!) is the same as \(startDate!)")
            }
            return false
        }else{
            return false
        }
        
        
    }
    
    class func getFormatedStringTimeFromDate(currentdate : Date )->String{
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.dateFormat="HH:mm"
        let dateInStringFormated=dateformatter.string(from: currentdate)
        return dateInStringFormated
    }
    
//    class func getFormatedStringFromDate(currentdate : Date )->String{
//        let dateformatter = DateFormatter()
//        dateformatter.locale = Locale.init(identifier: "en_US_POSIX")
//        dateformatter.dateStyle = DateFormatter.Style.medium
//        dateformatter.dateFormat="yyyy-MM-dd"
//        let dateInStringFormated=dateformatter.string(from: currentdate)
//        return dateInStringFormated
//    }
    
    class func getFormatedDateFromString(currentdate :String )-> String{
        let helloworld = currentdate
        var world = helloworld._bridgeToObjectiveC().substring(with: NSMakeRange(0,19))
        world = "\(world)Z"
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateformatter.date(from: world)
        dateformatter.dateFormat = "dd MMM yyyy"
        let dateInStringFormated=dateformatter.string(from: date!)
        
        return dateInStringFormated
    }
    
    class func getFormatedDateFullMonthFromString(currentdate :String )-> String{
        
        let helloworld = currentdate
        var world = helloworld._bridgeToObjectiveC().substring(with: NSMakeRange(0,19))
        world = "\(world)Z"
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateformatter.date(from: world)
        dateformatter.dateFormat = "MMMM dd yyyy"
        let dateInStringFormated=dateformatter.string(from: date!)
        
        return dateInStringFormated
    }
    
    class func getFormatedDateMonthFromString(currentdate :String )-> String{
       
        let helloworld = currentdate
        var world = helloworld._bridgeToObjectiveC().substring(with: NSMakeRange(0,19))
        world = "\(world)Z"
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateformatter.date(from: world)
        dateformatter.dateFormat = "MMMM dd yyyy hh:mm a"
        let dateInStringFormated=dateformatter.string(from: date!)
        
        return dateInStringFormated
    }
    
   
    
    class func getFormatedDayMonthFromString(currentdate :String )-> String{
        
        let helloworld = currentdate
        var world = helloworld._bridgeToObjectiveC().substring(with: NSMakeRange(0,19))
        world = "\(world)Z"
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateformatter.date(from: world)
        dateformatter.dateFormat = "dd MMM"
        let dateInStringFormated=dateformatter.string(from: date!)
        
        return dateInStringFormated
    }
    
    class func getFormatedTimeFromString(currentdate :String )-> String{
        
        let helloworld = currentdate
        var world = helloworld._bridgeToObjectiveC().substring(with: NSMakeRange(0,19))
        world = "\(world)Z"

        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateformatter.date(from: world)
        dateformatter.dateFormat = "hh:mm a"
        let dateInStringFormated=dateformatter.string(from: date!)
        
        return dateInStringFormated
    }
    
    class func getFormatedStringFromDate(currentdate :String )-> Date{
      
        let helloworld = currentdate
        var world = helloworld._bridgeToObjectiveC().substring(with: NSMakeRange(0,19))
        world = "\(world)Z"
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateformatter.date(from: world)
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let dateInStringFormated=dateformatter.string(from: date!)
        let StringFormated = dateformatter.date(from: dateInStringFormated)
        
        return StringFormated!
    }
    
    class func getCurrentDateString()-> String {
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateformatter.string(from: Date())
        return date
    }
    class func getDateFromString(currentdate: String )->String{

        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.dateFormat="EEEE, MMM d, yyyy"
        let date = dateformatter.date(from: currentdate)
        
        let dateformatter1 = DateFormatter()
        dateformatter1.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter1.dateStyle = DateFormatter.Style.medium
        dateformatter1.dateFormat="dd/MM/YYYY"
        let dateInStringFormated=dateformatter1.string(from: date!)
        print(dateInStringFormated)
        return dateInStringFormated
    }
    
    
    class func getDateTimeFromString(currentdate: String )->String{
        
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter.dateStyle = DateFormatter.Style.medium
        dateformatter.dateFormat="dd/MM/YYYY"
        let date = dateformatter.date(from: currentdate)
        
        let dateformatter1 = DateFormatter()
        dateformatter1.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter1.dateStyle = DateFormatter.Style.medium
        dateformatter1.dateFormat="dd/MM/YYYY"
        let dateInStringFormated=dateformatter1.string(from: date!)
        print(dateInStringFormated)
        return dateInStringFormated
    }
    
    class func getDateInMonthFormat(currentdate: String )->String{
        let dateformatter = DateFormatter()
        dateformatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter.dateFormat="dd/MM/yyyy HH:mm a"
        let date = dateformatter.date(from: currentdate)
        
        let dateformatter1 = DateFormatter()
        dateformatter1.locale = Locale.init(identifier: "en_US_POSIX")
        dateformatter1.dateFormat="MMMM dd, yyyy"
        if date != nil {
            let dateInStringFormated=dateformatter1.string(from: date!)
            print(dateInStringFormated)
            return dateInStringFormated
        }else{
            return currentdate
        }
    }
    
    class func calculateTimeAgo(startTimeStamp : Double, endTimeStamp : Double ) -> String {
        let startDate = Date.init(timeIntervalSince1970: startTimeStamp)
        
        let endDate = Date.init(timeIntervalSince1970: endTimeStamp)
        let outputTimeZone = NSTimeZone.local
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        outputDateFormatter.timeZone = outputTimeZone
        outputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let strDate1 =  outputDateFormatter.string(from: startDate as Date)
        let strDate2 =  outputDateFormatter.string(from: endDate)
        
        let startLocalDate = outputDateFormatter.date(from: strDate1)
        let endLocalDate = outputDateFormatter.date(from: strDate2)
        
        if startLocalDate != nil && endLocalDate != nil {
            
            var components = DateComponents()
            
            let calendar = NSCalendar.current
            let unitFlags = Set<Calendar.Component>([.day, .month, .year, .hour,.minute, .second ,.weekOfYear])
            components = calendar.dateComponents(unitFlags, from: startLocalDate! ,  to: endLocalDate!)
            let days = components.day!
            let hour = components.hour!
            let minutes = components.minute!
            let year = components.year!
            let month = components.month!
            let second = components.second!
            let week = components.weekOfYear!
            
            if(year > 0){
                return "\(year)\(NSLocalizedString("year", comment: ""))"
            }
            else if(month > 0){
                return "\(month)\(NSLocalizedString("month", comment: ""))"
            }
            else if(week > 0){
                return "\(week)\(NSLocalizedString("week", comment: ""))"
            }
            else if(days > 0){
                return "\(days)\(NSLocalizedString("days", comment: ""))"
            }
            else if(hour > 0){
                return "\(hour)\(NSLocalizedString("hrs", comment: ""))"
            }
            else if(minutes > 0){
                return "\(minutes)\(NSLocalizedString("min", comment: ""))"
            }
            else if(second > 0){
                return "\(second)\(NSLocalizedString("sec", comment: ""))"
            }
            else{
                return NSLocalizedString("just_now", comment: "")
            }
        }else{
            return ""
        }
        
    }
    
    class func calculateTimeAgo(startTimeStamp : Double ) -> String {
        let startDate = Date.init(timeIntervalSince1970: startTimeStamp)
        
        let endDate = Date()
        let outputTimeZone = NSTimeZone.local
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        outputDateFormatter.timeZone = outputTimeZone
        outputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let strDate1 =  outputDateFormatter.string(from: startDate as Date)
        let strDate2 =  outputDateFormatter.string(from: endDate)
        
        let startLocalDate = outputDateFormatter.date(from: strDate1)
        let endLocalDate = outputDateFormatter.date(from: strDate2)
        
        if startLocalDate != nil && endLocalDate != nil {
            
            var components = DateComponents()
            
            let calendar = NSCalendar.current
            let unitFlags = Set<Calendar.Component>([.day, .month, .year, .hour,.minute, .second ,.weekOfYear])
            components = calendar.dateComponents(unitFlags, from: startLocalDate! ,  to: endLocalDate!)
            let days = components.day!
            let hour = components.hour!
            let minutes = components.minute!
//            let year = components.year!
            // let month = components.month!
            let second = components.second!
//            let week = components.weekOfYear!
            
//            if(year > 0){
//                return "\(year)\(NSLocalizedString("year", comment: "")) \(NSLocalizedString("ago", comment: ""))"
//            }
//            else if(week > 0){
//                return "\(week)\(NSLocalizedString("week", comment: "")) \(NSLocalizedString("ago", comment: ""))"
//            }
//            else if(days > 0){
//                return "\(days)\(NSLocalizedString("days", comment: "")) \(NSLocalizedString("ago", comment: ""))"
//            }
            if(days > 0) {
              return convertDateTimeStampLocalTimeZone(timeStamp: startTimeStamp)
            }
            else if(hour > 0){
                return "\(hour)\(NSLocalizedString("hrs", comment: "")) \(NSLocalizedString("ago", comment: ""))"
            }
            else if(minutes > 0){
                return "\(minutes)\(NSLocalizedString("min", comment: "")) \(NSLocalizedString("ago", comment: ""))"
            }
            else if(second > 0){
                return "\(second)\(NSLocalizedString("sec", comment: "")) \(NSLocalizedString("ago", comment: ""))"
            }
            else{
                return NSLocalizedString("just_now", comment: "")
            }
        }else{
            return ""
        }
        
    }
    
    //MARK: UIImageView Methods
    
    class func calculateHeight(_ width: CGFloat , _ height: CGFloat , _ scaleWidth: CGFloat) -> CGFloat {
        print(width)
        print(height)
        let newHeight : CGFloat = (( height  / width ) * scaleWidth)
        return newHeight
    }
    
    
    class func convertStringBeforeSending(text : String) -> String{
        let data: Data = text.data(using: .nonLossyASCII)!
        if let strs: String = String(data: data as Data, encoding: .utf8) {
            return strs
        }else{
            return text
        }
        
    }
    
    class func convertStringAfterRecieving(text : String) -> String{
        let data: Data = text.data(using: .utf8)!
        if let strs: String = String(data: data as Data, encoding: .nonLossyASCII) {
            return strs
        }else{
            return text
        }
        
    }
    
}

class CustomUITextField: UITextField {
    func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    
}

