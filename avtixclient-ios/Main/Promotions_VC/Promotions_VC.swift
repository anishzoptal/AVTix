//
//  Promotions_VC.swift
//  avtixclient-ios
//
//  Created by eshan Cheema on 05/12/18.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class Promotions_VC: SlideInMenuManager {
   
    @IBOutlet weak var table_View: UITableView!
    @IBOutlet var dimmerView:      UIView!
    @IBOutlet var slideMenuView:   UIView!
    
    var arr_Promotions = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _dimmer = dimmerView;
        slideMenuContainer = slideMenuView;
        
        activeView = ActiveView.PROMOTIONS;
        setUpSlideMenu();
        arr_Promotions = (DBManager.getSharedInstance()?.find(byAvPromotions: ""))!
        print(arr_Promotions)
        
        // Do any additional setup after loading the view.
    }
    
    
}

extension Promotions_VC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableView Datasource  Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return arr_Promotions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PromotionCell
        cell.selectionStyle = .none
        
        let dic = arr_Promotions.object(at: indexPath.row) as! NSDictionary
        //name fromDate  toDate
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold("\(dic.value(forKey: "name")!)\n", size: 18)
            .normal("\(dic.value(forKey: "description")!) ", size: 14)
       
        cell.lbl_Detail.attributedText = formattedString
        cell.link = "\(dic.value(forKey: "url")!)"
        cell.img_BgView.sd_setImage(with: URL.init(string:"\(dic.value(forKey: "imageurl")!)"), placeholderImage: #imageLiteral(resourceName: "generic_pary_background"))
        let str_StartDate = AppManager.getFormatedDayMonthFromString(currentdate: "\(dic.value(forKey: "fromDate")!)")
        cell.lbl_Date.text = str_StartDate
        let str_TimeDate = AppManager.getFormatedDateFromString(currentdate: "\(dic.value(forKey: "toDate")!)")
        cell.lbl_Time.text = str_TimeDate
        return cell
    }
    
    
    //MARK: UITableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 232
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 232//UITableView.automaticDimension
    }
    

}
