//
//  MusicEventsTableView.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 03/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import UIKit

class EventsTableView: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noEventsView: UIView!
    var arr_AvEventData = NSArray()
    var arr_EventsData = NSMutableArray()
    var tabFunction : String!
//    var eventList : [EventCell]!;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = self;
        tableView.delegate = self;
        
        //
    }
    
    // Method is here
    
    func convertNextDate(dateString : String) -> NSArray {
        let arr = NSMutableArray()
        var somedateString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let myDate = dateFormatter.date(from: dateString)!
        for index in 0..<5 {
            let tomorrow = Calendar.current.date(byAdding: .day, value: index, to: myDate)
            somedateString = dateFormatter.string(from: tomorrow!)
            print("your next Date is \(somedateString)")
            arr.add(somedateString)
        }
       
        return arr
    }

    func displayData(){
        let arr_AvCategoriesData = (DBManager.getSharedInstance()?.find(byAvCategories: "") )!
        
        arr_AvEventData = (DBManager.getSharedInstance()?.find(byAvEvents: "") )!
        arr_EventsData.removeAllObjects()
        
       let arrDate = convertNextDate(dateString: AppManager.getCurrentDateString())

        for index in 0..<arr_AvCategoriesData.count {
            let dicCategory = arr_AvCategoriesData.object(at:index) as! NSDictionary
            let str = "\(dicCategory.value(forKey: "name")!)".uppercased()
            if str == tabFunction {
                let str_id = dicCategory.value(forKey: "id") as! String
                if tabFunction == "UPCOMING" {
                    let startDate = AppManager.getFormatedStringFromDate(currentdate: AppManager.getCurrentDateString())
                    let lastDate = AppManager.getFormatedStringFromDate(currentdate: arrDate.lastObject as! String)
                    
                    for index in 0..<arr_AvEventData.count {
                        let dic = arr_AvEventData.object(at: index) as! NSDictionary
                        let endDate = AppManager.getFormatedStringFromDate(currentdate: dic.value(forKey: "startdate") as! String)
                        
                        if startDate.compare(endDate) == .orderedAscending {
                            if lastDate.compare(endDate) == .orderedDescending {
                                print("Print Date :- \(endDate) \(lastDate)")
                                arr_EventsData.add(dic)
                            }
                        }
                    }
                }
                else {
                    for index in 0..<arr_AvEventData.count {
                        let dic = arr_AvEventData.object(at: index) as! NSDictionary
                        
                        if dic.value(forKey: "categroy") as! String == str_id {
                            arr_EventsData.add(dic)
                        }
                    }
                }
            }
        }
        tableView.reloadData();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //debug data, replace with actual data in the future
        
        if(arr_EventsData.count == 0){
            noEventsView.isHidden = false;
        }else{
            noEventsView.isHidden = true;
        }
        return arr_EventsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("EventCell", owner: self, options: nil)?.first as! EventCell;
        //debug data, replace with actual data in the future
        
        let dic = arr_EventsData.object(at: indexPath.row) as! NSDictionary
        cell.eventName.text = dic.value(forKey: "name") as? String
        cell.eventLocation.text = dic.value(forKey: "location") as? String
        cell.eventDescription.text = dic.value(forKey: "description") as? String
        cell.link = "\(dic.value(forKey: "url")!)"
        cell.backgroundImage.sd_setImage(with: URL.init(string:"\(dic.value(forKey: "imageurl")!)"), placeholderImage: #imageLiteral(resourceName: "generic_pary_background"))
        let str_StartDate = AppManager.getFormatedDateFromString(currentdate: "\(dic.value(forKey: "startdate")!)")
        cell.lbl_Date.text = str_StartDate
        let str_TimeDate = AppManager.getFormatedTimeFromString(currentdate: "\(dic.value(forKey: "startdate")!)")
        cell.lbl_Time.text = str_TimeDate
        
        return cell
        
    }
}
