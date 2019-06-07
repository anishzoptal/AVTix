//
//  ServerManager.swift
//  
//
//  Created by Manpreet Kaur on 11/01/18.
//  Copyright © 2018 Vibrant appz All rights reserved.
//

import UIKit
import CFNetwork
import Alamofire
import SwiftyJSON
import MobileCoreServices


typealias ServerSuccessCallBack = (_ json:JSON)->Void
typealias ServerFailureCallBack=(_ error:Error?)->Void
typealias ServerProgressCallBack = (_ progress:Double?) -> Void
typealias ServerNetworkConnectionCallBck = (_ reachable:Bool) -> Void

class ServerManager: NSObject {
    var HUD:MBProgressHUD!
    
    override init() {
        super.init()
    }
    
    class var shared:ServerManager{
        struct  Singlton{
            static let instance = ServerManager()
        }
        return Singlton.instance
    }
    
    //MARK:-documentsDirectoryURL-
    lazy var documentsDirectoryURL : URL = {
        let documents = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return documents
    }()
    
    private lazy var backgroundManager: Alamofire.SessionManager = {
        let bundleIdentifier = Bundle.main.bundleIdentifier
        let configure  = URLSessionConfiguration.background(withIdentifier: bundleIdentifier! + ".background")
        // configure.timeoutIntervalForRequest = 30
        
        let session = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: bundleIdentifier! + ".background"))
        session.startRequestsImmediately = true
        return session
    }()
    
    private lazy var sessionManager: Alamofire.SessionManager = {
        let configure  = URLSessionConfiguration.default
        configure.timeoutIntervalForRequest = 30
        return Alamofire.SessionManager(configuration: configure)
    }()
    
    var backgroundCompletionHandler: (() -> Void)? {
        get {
            return backgroundManager.backgroundCompletionHandler
        }
        set {
            backgroundManager.backgroundCompletionHandler = newValue
        }
    }
    
    
    // MARK:  showAlert
    
    func showAlert(_ title:String, message:String){
        NotificationView.showNotificationView(image: UIImage(named: "logo"), withTitle: title, withMessage: message)
    }
    
    
    //MARK:- showAlert-
    func showAlertControl(from ViewController:UIViewController,withTitle title:String = kAlertTitle,withMessage message:String?){
        let alertController:UIAlertController =  UIAlertController.showAlertInViewController(viewController: ViewController, withTitle: title, message: message, cancelButtonTitle: "Okay", destructiveButtonTitle: nil, otherButtonTitles: nil) { (alert:UIAlertController?, action:UIAlertAction?, index:Int?) in
            
        }
        alertController.view.tintColor = UIColor.smAppDefaultColor()
    }
    
    //MARK: Check Network Connetion-
    
    func CheckNetwork() -> Bool{
        let is_net = Reachability.isConnectedToNetwork()
        if(is_net==true){
            return true;
        }
        else{
            let image : UIImage = UIImage(named: "logo")!
            NotificationView.showNotificationView(image: image, withTitle: "No Internet Connection!", withMessage: "Internet Connection is not available,Please check Your network Settings!", AutoHide: true, onTouchHandler: { (finished:Bool) in
                if #available(iOS 10, *) {
                    UIApplication.shared.open(URL(string: "prefs:root=WIFI")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
                else{
                    UIApplication.shared.openURL(URL(string: "prefs:root=WIFI")!)
                }
            })
            return false;
        }
    }
    
    func checkNetworkConnetion(OnConnetion Completion:@escaping ServerNetworkConnectionCallBck){
        let manager = NetworkReachabilityManager(host: "www.apple.com")
        manager?.listener = { status in
            DispatchQueue.main.async {
                print("status \(status)")
                switch status{
                case .reachable(.ethernetOrWiFi),.reachable(.wwan):
                    Completion(true)
                    break
                case .notReachable,.unknown:
                    manager?.stopListening()
                    let image : UIImage = UIImage(named: "logo")!
                    NotificationView.showNotificationView(image: image, withTitle: "No Internet Connection!", withMessage: "Internet Connection is not available,Please check Your network Settings!", AutoHide: true, onTouchHandler: { (finished:Bool) in
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(URL(string: "prefs:root=WIFI")!, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                        }
                        else{
                            UIApplication.shared.openURL(URL(string: "prefs:root=WIFI")!)
                        }
                    })
                    Completion(false)
                    break
                }
            }
        }
        
        manager?.startListening()
        
        
    }
    
    // MARK: showHud
    func showHud(showInView myView:UIView = AppDelegate.sharedDelegate.window!,label title: String = ""){
        //        HUD  = MBProgressHUD.showAdded(to: myView, animated: true)
        //        HUD.contentColor = UIColor.darkGray
        //        HUD.label.text = title
        
        HUD  = MBProgressHUD.showAdded(to: myView, animated: true)
        HUD.mode = .customView
        HUD.customView = UIImageView(image: #imageLiteral(resourceName: "loader"))
        HUD.customView?.superview?.backgroundColor = UIColor.init(red: 27.0/255.0, green: 81.0/255.0, blue: 118.0/255.0, alpha: 0.25)
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = 2.0 * Double.pi
        animation.duration = 1
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        HUD.customView?.layer.add(animation, forKey: "rotationAnimation")
    
        HUD.contentColor = UIColor.white
        HUD.label.text = title
        
    }
    
    // MARK: hidHud
    func hidHud(){
        if (HUD != nil) {
            if !HUD.isHidden {
                self.HUD .hide(animated: true)
                
            }
            
        }
    }
    
    //MARK: shoHudProgressBar
    func shoHudProgressBar(showInView myView:UIView = AppDelegate.sharedDelegate.window! , ProgressHudMode hudeMode:MBProgressHUDMode = .determinateHorizontalBar,titleLabel title:String? = ""){
        HUD =  MBProgressHUD.showAdded(to: myView, animated: true)
        HUD.mode = .determinateHorizontalBar
        HUD.contentColor = UIColor.smAppDefaultColor()
        
        HUD.label.text = title
    }
    
    //MARK: recieveProgressData
    func recieveProgressData( setProgress myprogress:Float ,  label : String){
        //var progress:Float = HUD!.progress
        //  if progress < 1.0 {
        // progress = progress + 0.1\
        
        
        // HUD.messageString =  label
        HUD.progress = myprogress
        
        //}
    }
    
    //    lazy var appHeader:[String:String] = {
    //        return ["Content-Type":"application/json"]
    //    }()
    
    var appHeader:[String:String] = {
        if let authToken = UserDefaults.standard.object(forKey: kAuthToken) as? String {
            return ["AUTHENTICATIONTOKEN" : authToken]
        }else{
            return ["AUTHENTICATIONTOKEN" : ""]
        }
    }()
    
    func getAppHeader() -> [String:String] {
        if let authToken = UserDefaults.standard.object(forKey: kAuthToken) as? String {
            return ["AUTHENTICATIONTOKEN" : authToken]
        }else{
            return ["AUTHENTICATIONTOKEN" : ""]
        }
    }
    //MARK:-httpPost-
    
    func httpPost(request url: String!,params: [String:Any]!,successHandler:ServerSuccessCallBack?,failureHandler:ServerFailureCallBack?){
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: self.getAppHeader() ).responseJSON { (response:DataResponse<Any>) in
            print(url)
            print(params)
            // print(response)
            
            if let backToString = String(data: response.data!, encoding: String.Encoding.utf8) {
                print(backToString)
            }
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response\(response)")
                    let json = try! JSON(data: response.data!)
                    if (successHandler != nil){
                        if ((json.null) == nil){
                            successHandler!(json)
                        }
                    }
                }
                break
            case .failure(_):
                if (failureHandler != nil){
                    failureHandler!(response.result.error!)
                }
                break
            }
        }
        
    }
    
    func httpPost1(request url: String!,params: [String:Any]!,successHandler:ServerSuccessCallBack?,failureHandler:ServerFailureCallBack?){
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            print(url)
            print(params)
            print(response)
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response\(response)")
                    let json = try! JSON(data: response.data!)
                    if (successHandler != nil){
                        if ((json.null) == nil){
                            successHandler!(json)
                        }
                    }
                }
                break
            case .failure(_):
                if (failureHandler != nil){
                    failureHandler!(response.result.error!)
                }
                break
            }
        }
        
    }
    
    //MARK:-httpGetRequest-
    
    func httpGet(request url:String! ,successHandler:ServerSuccessCallBack?,failureHandler:ServerFailureCallBack?,progressHandler:ServerProgressCallBack?){
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(request).responseJSON {
            (response:DataResponse<Any>) in
            print(response)
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response\(response)")
                    let json = try! JSON(data: response.data!)
                    if (successHandler != nil){
                        if ((json.null) == nil){
                            successHandler!(json)
                        }
                    }
                }
                break
            case .failure(_):
                if (failureHandler != nil){
                    failureHandler!(response.result.error!)
                }
                break
            }
        }
    }
    
    
    func httpGet1(request url:String! ,successHandler:ServerSuccessCallBack?,failureHandler:ServerFailureCallBack?,progressHandler:ServerProgressCallBack?){
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(request).responseJSON {
            (response:DataResponse<Any>) in
            print(response)
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("response\(response)")
                    let json = try! JSON(data: response.data!)
                    if (successHandler != nil){
                        if ((json.null) == nil){
                            successHandler!(json)
                        }
                    }
                }
                break
            case .failure(_):
                if (failureHandler != nil){
                    failureHandler!(response.result.error!)
                }
                break
            }
        }
    }
    
    //MARK:-httpUploadRequest-
    
    func httpUpload(api:String! ,params:[String:Any]?, multipartObject :[MultipartData]?,successHandler:ServerSuccessCallBack?,failureHandler:ServerFailureCallBack?,progressHandler:ServerProgressCallBack?){
        if (multipartObject != nil) {
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                if let mediaList  = multipartObject{
                    for object in mediaList{
                        multipartFormData.append(object.media, withName: object.mediaUploadKey, fileName: object.fileName, mimeType: object.mimType)
                    }
                }
                if (params != nil){
                    for (key, value) in params! {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }, to: api,headers:nil, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                        if (progressHandler != nil){
                            progressHandler!(Progress.fractionCompleted)
                        }
                    })
                    upload.responseString(completionHandler: { (response) in
                        
                        let json = try! JSON(data: response.data!)
                        print("response\(response)")
                        successHandler!(json)
                    })
                    
                case .failure(let encodingError):
                    if (failureHandler != nil){
                        failureHandler!(encodingError as NSError )
                    }
                }
            })
        }else{
            self.httpPost(request: api, params: params, successHandler: successHandler, failureHandler: failureHandler)
        }
    }
    

    //WITH Multiple  IMAGE
    
    func httpUploadMultipleImage(apiUrl:String,parameter:[String:Any]?,image:UIImage ,withKey: String,image1:UIImage ,withKey1: String,image2:UIImage ,withKey2: String,image3:UIImage ,withKey3: String,image4:UIImage ,withKey4: String,image5:UIImage ,withKey5: String, successHandler:@escaping ServerSuccessCallBack,progressHandler:@escaping ServerProgressCallBack ,failureHandlers:@escaping ServerFailureCallBack) {
        let imageData = image.jpegData(compressionQuality: 0.3)!
        let imageData1 = image1.jpegData(compressionQuality: 0.3)!
        let imageData2 = image2.jpegData(compressionQuality: 0.3)!
        let imageData3 = image3.jpegData(compressionQuality: 0.3)!
        let imageData4 = image4.jpegData(compressionQuality: 0.3)!
        let imageData5 = image5.jpegData(compressionQuality: 0.3)!
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: withKey, fileName: "\(Int64(NSDate().timeIntervalSince1970  * 1000))_image.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(imageData1, withName: withKey, fileName: "\(Int64(NSDate().timeIntervalSince1970  * 1000))_image.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(imageData2, withName: withKey, fileName: "\(Int64(NSDate().timeIntervalSince1970  * 1000))_image.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(imageData3, withName: withKey, fileName: "\(Int64(NSDate().timeIntervalSince1970  * 1000))_image.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(imageData4, withName: withKey, fileName: "\(Int64(NSDate().timeIntervalSince1970  * 1000))_image.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(imageData5, withName: withKey, fileName: "\(Int64(NSDate().timeIntervalSince1970  * 1000))_image.jpeg", mimeType: "image/jpeg")
            if (parameter != nil){
                for (key, value) in parameter! {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
        }, to: apiUrl,headers: self.getAppHeader(), encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    progressHandler(progress.fractionCompleted)
                    
                })
                upload.responseJSON { response in
                    if response.result.value != nil{
                        print(response.request ?? "")  // original URL request
                        print(response.response ?? "") // URL response
                        print(response.data ?? "")     // server data
                        print(response.result)   // result of response serialization
                        let json = try! JSON(data: response.data!)
                        print(json)
                        if ((json.null) == nil){
                            successHandler(json)
                        }
                        
                    }
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    //WITH ONE SINGLE IMAGE
    
    func httpUploadImage(apiUrl:String,parameter:[String:Any]?,image:UIImage ,withKey: String, successHandler:@escaping ServerSuccessCallBack,progressHandler:@escaping ServerProgressCallBack ,failureHandlers:@escaping ServerFailureCallBack) {
        let imageData = image.jpegData(compressionQuality: 0.5)!
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData, withName: withKey, fileName: "\(Int64(NSDate().timeIntervalSince1970  * 1000))_image.jpeg", mimeType: "image/jpeg")
            
            if (parameter != nil){
                for (key, value) in parameter! {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
        }, to: apiUrl,headers: self.getAppHeader(), encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    progressHandler(progress.fractionCompleted)
                    
                })
                upload.responseJSON { response in
                    if response.result.value != nil{
                        print(response.request ?? "")  // original URL request
                        print(response.response ?? "") // URL response
                        print(response.data ?? "")     // server data
                        print(response.result)   // result of response serialization
                        let json = try! JSON(data: response.data!)
                        print(json)
                        if ((json.null) == nil){
                            successHandler(json)
                        }
                        
                    }
                    
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        })
    }
    
    
    //MARK:-httpDownloadRequest-
    func httpDownload(request api:String! ,enableBackGroundTask isBackground:Bool,successHandler:@escaping (_ result:Any)->Void?,failureHandler:ServerFailureCallBack?,progressHandler:ServerProgressCallBack?){
        let fileUrl  = URL(string: api)
        let request = URLRequest(url: fileUrl!)
        let destination: DownloadRequest.DownloadFileDestination = { filePath,response in
            let directory : NSURL = (self.documentsDirectoryURL as NSURL)
            let fileURL = directory.appendingPathComponent(response.suggestedFilename!)!
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        if  isBackground{
            backgroundManager.download(request, to: destination).response(completionHandler: { (response:DefaultDownloadResponse) in
                if response.error != nil{
                    if (failureHandler != nil){
                        failureHandler!(response.error! as NSError )
                    }
                }else{
                    if (response.destinationURL != nil){
                        successHandler(response.destinationURL!)
                    }
                }
            }).downloadProgress { (progress) in
                if (progressHandler != nil){
                    progressHandler!(progress.fractionCompleted)
                }
            }
        }else{
            
            Alamofire.download(request, to: destination).responseJSON { (response:DownloadResponse<Any>) in
                switch(response.result){
                case .success(_):
                    if response.result.value != nil{
                        print("response\(response)")
                        successHandler(response.destinationURL!)
                    }
                    break
                case .failure(_):
                    if (failureHandler != nil){
                        failureHandler!(response.result.error! )
                    }
                    break
                }
                }.downloadProgress { (progress) in
                    if (progressHandler != nil){
                        progressHandler!(progress.fractionCompleted)
                    }
            }
        }
    }
    //MARK:-httpBackgroundTaskRequest-
    func httpBackgroundTaskRequest(api:String!,params:[String:Any]?,multipartObject :[MultipartData]? ,httpMethod ispostMethod:Bool = true,successHandler:ServerSuccessCallBack?,failureHandler:ServerFailureCallBack?,progressHandler:ServerProgressCallBack?){
        let method:HTTPMethod = ispostMethod == true ? .post : .get
        if (multipartObject != nil) && (multipartObject?.count)! > 0 {
            backgroundManager.upload(multipartFormData: { (multipartFormData) in
                if let mediaList  = multipartObject{
                    for object in mediaList{
                        multipartFormData.append(object.media, withName: object.mediaUploadKey, fileName: object.fileName, mimeType: object.mimType)
                    }
                }
                if (params != nil){
                    for (key, value) in params! {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }, to: api,headers:appHeader, encodingCompletion: { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                        if (progressHandler != nil){
                            progressHandler!(Progress.fractionCompleted)
                        }
                    })
                    
                    upload.responseJSON { response in
                        if response.result.value != nil{
                            print("response\(response)")
                            let json = try! JSON(data: response.data!)
                            if (successHandler != nil){
                                successHandler!(json)
                            }
                        }
                    }
                    
                case .failure(let encodingError):
                    if (failureHandler != nil){
                        failureHandler!(encodingError as NSError )
                    }
                }
            })
            
            backgroundManager.delegate.sessionDidFinishEventsForBackgroundURLSession = {
                session in
                // record the fact that we're all done moving stuff around
                // now, call the saved completion handler
                self.backgroundCompletionHandler?()
                self.backgroundCompletionHandler = nil
            }
            
            backgroundManager.backgroundCompletionHandler = {
                // finshed task
            }
        }else{
            backgroundManager.request("\(api!)", method: method, parameters: params, headers: self.appHeader).responseJSON { (response:DataResponse<Any>) in
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("response\(response)")
                        let json = try! JSON(data: response.data!)
                        if (successHandler != nil){
                            successHandler!(json)
                        }
                        
                    }
                    break
                    
                case .failure(_):
                    if (failureHandler != nil){
                        failureHandler!(response.result.error! )
                    }
                    
                    break
                    
                }
                
            }
            
            backgroundManager.delegate.sessionDidFinishEventsForBackgroundURLSession = {
                session in
                
                // record the fact that we're all done moving stuff around
                
                // now, call the saved completion handler
                
                self.backgroundCompletionHandler?()
                self.backgroundCompletionHandler = nil
            }
            //            backgroundManager.backgroundCompletionHandler = {
            //
            //            }
        }
        
    }
    
    
    func errorMessage(errorCode: Int , errorMessage: String, viewController : UIViewController){
        switch errorCode {
        case 201:
            MessageView.show(in: viewController.view, withMessage: errorMessage)
            break
        case 0:
            MessageView.show(in: viewController.view, withMessage: errorMessage)
            break
        case 203:
            MessageView.show(in: viewController.view, withMessage: errorMessage)
            break
        case 204:
            MessageView.show(in: viewController.view, withMessage: errorMessage)
            break
        case 205:
            MessageView.show(in: viewController.view, withMessage: "Opps! Record not found")
            break
        case 404:
//            UserDefaults.SFSDefault(setBool: false, forKey: kIsLogin)
//            let objSplash : SplashVC = AppDelegate.sharedDelegate.getViewControllerFromCustomer(viewControllerName: "SplashVC") as! SplashVC
//            AppDelegate.sharedDelegate.navigation = UINavigationController.init(rootViewController: objSplash)
//            AppDelegate.sharedDelegate.window?.rootViewController = AppDelegate.sharedDelegate
//                .navigation
            break
        default:
            break
        }
    }
    
}

//MARK:-AppUtility-

class AppUtility:NSObject{
    
    class func setGradientColor(_ colors:[Any],view:UIView){
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colors
        gradient.locations = [0.0, 0.25, 0.75, 1.0]
        view.layer.addSublayer(gradient)
    }
    //MARK:-mimeTypeForPath-
    
    class func mimeType(forPath filePath:URL)->String{
        var  mimeType:String;
        let fileExtension:CFString = filePath.pathExtension as CFString
        let UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, nil);
        let str = UTTypeCopyPreferredTagWithClass(UTI!.takeUnretainedValue(), kUTTagClassMIMEType);
        if (str == nil) {
            mimeType = "application/octet-stream";
        } else {
            mimeType = str!.takeUnretainedValue() as String
        }
        return mimeType
    }
    
    //MARK:-filename-
    
    class func filename(Prefix:String , fileExtension:String)-> String{
        let dateformatter=DateFormatter()
        dateformatter.dateFormat="MddyyHHmmss"
        let dateInStringFormated=dateformatter.string(from: Date() )
        return "\(Prefix)_\(dateInStringFormated).\(fileExtension)"
    }
    
    //MARK:-getJsonObjectDict-
    
    class func getJsonObjectDict(responseObject:Any)->[String:Any]{
        var anyObj :[String:Any]!
        do{
            anyObj = try JSONSerialization.jsonObject(with: (responseObject as! NSData) as Data, options: []) as? [String:Any]
            return anyObj!
            
        } catch  {
            print("json error: \(error)")
        }
        return anyObj!
    }
    
    //MARK:-getJsonObjectArray-
    
    class func JSONArray(responseObject:Any)->[Any]{
        var anyObj :[Any] = [Any]()
        do{
            anyObj = try JSONSerialization.jsonObject(with: (responseObject as! NSData) as Data, options: []) as! [Any]
            return anyObj
            
        } catch  {
            print("json error: \(error)")
        }
        return anyObj
    }
    
    //MARK:-JSONStringify-
    
    class func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String{
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value){
            if let data = try? JSONSerialization.data(withJSONObject: value, options: options){
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
                    return string as String
                }
            }
        }
        return ""
    }
    
    //MARK:-getJsonData-
    class func JSONData(responseObject:Any)->Data{
        var data :Data!
        do{
            data = try JSONSerialization.data(withJSONObject: responseObject, options: []) as Data?
            return data!
            
        } catch  {
            print("json error: \(error)")
        }
        return data!
    }
    
    
}


class MultipartData: NSObject{
    var media:Data!
    var mediaUploadKey:String!
    var fileName:String!
    var mimType:String!
    
    override init(){
        
    }
    
    init(medaiObject object:Any!,mediaKey uploadKey: String!,isPNG: Bool = true) {
        if (object != nil) , (uploadKey != nil) {
            if  object is UIImage {
                if let imageObject = object as? UIImage {
                    self.media =  imageObject.pngData() /*isPNG == true ? imageObject.uncompressedPNGData : imageObject.lowQualityJPEGNSData*/
                    self.mimType = "image/png"
                    self.fileName = AppUtility.filename(Prefix: "image_drycleaner_\(UserDefaults.SFSDefault(valueForKey: "user_id"))", fileExtension: "jpeg")
                }
            }else{
                if  let filepath = object as? String{
                    let url = NSURL.fileURL(withPath: filepath)
                    self.fileName = url.lastPathComponent
                    self.media = try! Data(contentsOf: url) //NSData(contentsOf: url)
                    self.mimType = AppUtility.mimeType(forPath: url )
                }
            }
            self.mediaUploadKey = uploadKey
        }
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        if let media = aDecoder.decodeObject(forKey: "mediaData") as? Data {
            
            self.media = media
        }
        if let mediaUploadKey = aDecoder.decodeObject(forKey: "mediaUploadKey") as? String {
            
            self.mediaUploadKey = mediaUploadKey
        }
        if let fileName = aDecoder.decodeObject(forKey: "fileName") as? String {
            
            self.fileName = fileName
        }
        if let mimType = aDecoder.decodeObject(forKey: "mimType") as? String {
            
            self.mimType = mimType
        }
        
    }
    open func encodeWithCoder(_ aCoder: NSCoder){
        if let media = self.media{
            aCoder.encode(media, forKey: "media")
        }
        if let mediaUploadKey = self.mediaUploadKey {
            aCoder.encode(mediaUploadKey, forKey: "mediaUploadKey")
        }
        if let fileName = self.fileName {
            aCoder.encode(fileName, forKey: "fileName")
        }
        if let mimType = self.mimType {
            aCoder.encode(mimType, forKey: "mimType")
        }
        
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
