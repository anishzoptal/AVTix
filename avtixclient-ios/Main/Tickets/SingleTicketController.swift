//
//  BackgroundVideoController.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 11/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class SingleTicketController: UIViewController {
    
    var videoPlayer : AVPlayer!
    var videoLayer  : AVPlayerLayer!
    var dic_Info    = NSDictionary()
    var dic_Type    = NSDictionary()
    
    @IBOutlet weak var lbl_ticketUsed: UILabel!
    @IBOutlet var QRCode:        UIImageView!
    @IBOutlet var type:          UILabel!
    @IBOutlet var number:        UILabel!
    @IBOutlet var date:          UILabel!
    @IBOutlet var time:          UILabel!
    @IBOutlet var eventName:     UILabel!
    @IBOutlet var location:      UILabel!
    @IBOutlet weak var btn_Star:       UIButton!
    @IBOutlet weak var btn_VIP:        UIButton!
    @IBOutlet weak var btn_Msg:        UIButton!
    @IBOutlet weak var img_BackGround: UIImageView!
    
    var authLoaded : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        if dic_Type.count != 0 {
            if dic_Type.value(forKey: "type") as! String == "1" {
                img_BackGround.isHidden = true
                setUpBackgroundVideo()
            }
            else {
                img_BackGround.sd_setImage(with: URL.init(string:"\(dic_Type.value(forKey: "url")!)"), placeholderImage: #imageLiteral(resourceName: "clubing_ticket_background"))
                
            }
        }
        setUpTicketData();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        authLoaded = false
        lbl_ticketUsed.isHidden = true
        btn_Msg.isHidden  = false
        btn_VIP.isHidden  = false
        btn_Star.isHidden = false
        if dic_Info.value(forKey: "usedBy") as! String == "1" {
            lbl_ticketUsed.isHidden = false
            btn_Msg.isHidden = true
            btn_VIP.isHidden = true
            btn_Star.isHidden = true
        }
        else {
            
            let holdRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.openTicketAuth(sender:)))
            view.addGestureRecognizer(holdRecognizer);
        }
    }
    
    @objc func setUpBackgroundVideo(){
      //  let video = Bundle.main.path(forResource: "ticket_background", ofType: "mp4");
       
        let url = URL.init(string: "\(dic_Type.value(forKey: "url")!)")
       // let url = URL.init(string: "http://client.avtix.com/resources/video_bg/3.mp4")

        videoPlayer = AVPlayer(url: url!)
        videoPlayer.actionAtItemEnd = .none;
        videoLayer = AVPlayerLayer(player: videoPlayer);
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        videoLayer.frame = view.layer.bounds;
        view.layer.insertSublayer(videoLayer, at: 0);
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem)
        videoPlayer.play();
    }
    
    @objc func playerItemDidReachEnd(notification : Notification){
        let player: AVPlayerItem = notification.object as! AVPlayerItem;
        player.seek(to: CMTime.zero, completionHandler: nil);
    }
    
    func setUpTicketData() {
        let str_StartDate = AppManager.getFormatedDateFromString(currentdate: "\(dic_Info.value(forKey: "endDate")!)")
        let str_TimeDate = AppManager.getFormatedDayMonthFromString(currentdate: "\(dic_Info.value(forKey: "endDate")!)")
        type.text      = dic_Info.value(forKey: "type") as? String
        number.text    = dic_Info.value(forKey: "amount") as? String
        eventName.text = dic_Info.value(forKey: "name") as? String
        location.text  = dic_Info.value(forKey: "location") as? String
        date.text      = str_StartDate
        time.text      = str_TimeDate
        self.genrateQRCode(from: "\(dic_Info.value(forKey: "id")!)")
    }
    
    @objc func openTicketAuth(sender: UILongPressGestureRecognizer){
        if(!authLoaded){
            authLoaded = true;
            performSegue(withIdentifier: "ticketAuth", sender: self);
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ticketAuth = segue.destination as! TicketAuthViewController;
        ticketAuth.str_TicketId = "\(dic_Info.value(forKey: "id")!)"
    }
    
    @IBAction func StarBtnAction(_ sender: Any) {
        FetchTicketActionDataFromServer(str_TicketId: "\(dic_Info.value(forKey: "id")!)", str_ActionId: "1")
    }
    
    @IBAction func VIPBtnAction(_ sender: Any) {
         FetchTicketActionDataFromServer(str_TicketId: "\(dic_Info.value(forKey: "id")!)", str_ActionId: "0")
    }
    
    @IBAction func MsgBtnAction(_ sender: Any) {
         FetchTicketActionDataFromServer(str_TicketId: "\(dic_Info.value(forKey: "id")!)", str_ActionId: "2")
    }
    
}

extension SingleTicketController {
    
    //MARK:
    //MARK: Fetch data from Ticket Action Loader
    func FetchTicketActionDataFromServer(str_TicketId: String!, str_ActionId: String!) {
        
        let param = [
            "AppVersion"         : "1.0.1",
            "ClientId"           : loggedInUser.ClientId,
            "DeviceType"         : "1",
            "ClientPNID"         : AppManager.getDeviceToken(),
            "DeviceId"           : "\(UserDefaults.SFSDefault(valueForKey: kDeviceId))",
            "TicketId"           : str_TicketId,
            "ActionId"           : str_ActionId
            ] as [String : Any]
        
        if let theJSONData = try?  JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
            let theJSONText = String(data: theJSONData, encoding: String.Encoding.ascii) {
            print("JSON string = \n\(theJSONText)")
            let parameter  = ["clientPacket": theJSONText]
            ServerManager.shared.showHud(showInView: self.view, label: "")
            ServerManager.shared.httpPost(request: "\(API_TICKETACTION)", params: parameter, successHandler: { (JSON) in
                 ServerManager.shared.hidHud()
              
                let responseError = JSON["ResponseErrors"].arrayObject
                
                if responseError?.count == 0 {
                    
                }
                let dic = responseError![0] as! NSDictionary
                ServerManager.shared.hidHud()
                AppManager.showErrorDialog(viewControler: self, message: dic.value(forKey: "ErrorMessage") as! String)
                
            }) { (error) in
                ServerManager.shared.hidHud()
                print(error.debugDescription)
                 AppManager.showErrorDialog(viewControler: self, message: error.debugDescription )
            }
        }
    }
    func genrateQRCode(from id:String) {
        //Genrate code from ticket id
        let data = id.data(using: String.Encoding.ascii)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        qrFilter.setValue(data, forKey: "inputMessage")
        guard let qrImage = qrFilter.outputImage else { return }
        
        //Transform image to higher scale
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        
        // Create the filter
        guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return }
        // Set the input image to what we generated above
        colorInvertFilter.setValue(scaledQrImage, forKey: "inputImage")
        // Get the output CIImage
        guard let outputInvertedImage = colorInvertFilter.outputImage else { return }
        // Do any additional setup after loading the view.
        // Create the filter
        guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return }
        // Set the input image to the colorInvertFilter output
        maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
        // Get the output CIImage
        guard let outputCIImage = maskToAlphaFilter.outputImage else { return }
        // Get a CIContext
        let context = CIContext()
        // Create a CGImage *from the extent of the outputCIImage*
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return }
        // Finally, get a usable UIImage from the CGImage
        self.QRCode.image = UIImage(cgImage: cgImage)
    }
    
}

