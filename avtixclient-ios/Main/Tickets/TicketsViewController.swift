//
//  TicketController.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 09/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

class TicketsViewController: SlideInMenuManager, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var ticketCollection: UICollectionView!
    @IBOutlet var dimmerView:       UIView!
    @IBOutlet var slideMenuView:    UIView!
    @IBOutlet var noEventsView:     UIView!
    
    var selectedTicketData   : Ticket!
    var arr_Tickets          = NSArray()
    var arr_Type             = NSArray()
    var arrType              = NSArray()
    var arr_AvCategoriesData = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        _dimmer = dimmerView;
        slideMenuContainer = slideMenuView
        
        activeView = ActiveView.TICKETS
        setUpSlideMenu()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(ticketUpdate), name: Notification.Name("ticketUpdate"), object: nil)
    }
    @objc func ticketUpdate() {
        arr_AvCategoriesData = (DBManager.getSharedInstance()?.find(byAvCategories: "") )!
        
        arr_Tickets = (DBManager.getSharedInstance()?.find(byAvTickets: "") )!
        let cell = UINib(nibName: "TicketCell", bundle: nil)
        ticketCollection.register(cell, forCellWithReuseIdentifier: "ticketCell")
        ticketCollection.delegate = self
        ticketCollection.dataSource = self
        ticketCollection.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arr_Tickets = (DBManager.getSharedInstance()?.find(byAvTickets: "") )!

        let cell = UINib(nibName: "TicketCell", bundle: nil)
        ticketCollection.register(cell, forCellWithReuseIdentifier: "ticketCell");
        ticketCollection.delegate = self
        ticketCollection.dataSource = self
        ticketCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(arr_Tickets.count == 0){
            noEventsView.isHidden = false
        }else{
            noEventsView.isHidden = true
        }

        return arr_Tickets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ticketCollection.dequeueReusableCell(withReuseIdentifier: "ticketCell", for: indexPath) as! TicketCell
        let dic = arr_Tickets.object(at: indexPath.row) as! NSDictionary
        let str = "\(dic.value(forKey: "usedBy")!)"
        cell.lbl_Used.isHidden = true
        cell.backgroundImage.isHidden = false
        if  str == "1" {
            cell.lbl_Used.isHidden = false
            cell.backgroundImage.isHidden = true
        }
        if dic.value(forKey: "code") as! String != "(null)" {
            if str.count != 0 {
                arrType = (DBManager.getSharedInstance()?.find(byAvBackgrounds: "\(dic.value(forKey: "category")!)", backgroundCategory: "1"))!
            }
            else {
                arrType = (DBManager.getSharedInstance()?.find(byAvBackgrounds: "\(dic.value(forKey: "category")!)", backgroundCategory: "1"))!
            }
        }
        else {
            arrType = (DBManager.getSharedInstance()?.find(byAvBackgrounds: "\(dic.value(forKey: "code")!)", backgroundCategory: "1"))!
        }
        cell.backgroundImage.image = UIImage.init(named: "c\(dic.value(forKey: "category")!)".localizedKey())
        let dic_type = arrType.object(at: 0) as! NSDictionary
        cell.img_Photo.sd_setImage(with: URL.init(string:"\(dic_type.value(forKey: "url")!)"), placeholderImage: #imageLiteral(resourceName: "clubing_ticket_background"))
        
        cell.eventName.text = "\(dic.value(forKey: "name")!)"
        cell.location.text = "\(dic.value(forKey: "location")!)"
        cell.amount.text = "\(dic.value(forKey: "amount")!)"
        cell.type.text = "\(dic.value(forKey: "type")!)"
        let str_StartDate = AppManager.getFormatedDateMonthFromString(currentdate: "\(dic.value(forKey: "endDate")!)")
       
        cell.dateTime.text = str_StartDate
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let dic = arr_Tickets.object(at: indexPath.row) as! NSDictionary
        let vc = AppDelegate.sharedDelegate.getViewControllerFromCustomer(viewControllerName: "SingleTicketController") as! SingleTicketController
        print("Print Dictionary === \(dic)")
        let str = "\(dic.value(forKey: "code")!)"
        if dic.value(forKey: "code") as! String != "(null)" {
            if str.count != 0 {
                arr_Type = (DBManager.getSharedInstance()?.find(byAvBackgrounds: "\(dic.value(forKey: "code")!)", backgroundCategory: ""))!
                if arr_Type.count != 0 {
                    let dic_type = arr_Type.object(at: 0) as! NSDictionary
                    vc.dic_Type = dic_type
                }
                else {
                    arr_Type = (DBManager.getSharedInstance()?.find(byAvBackgrounds: "\(dic.value(forKey: "category")!)", backgroundCategory: "1"))!
                    let dic_type = arr_Type.object(at: 0) as! NSDictionary
                    vc.dic_Type = dic_type
                }
               
            }
            else {
                arr_Type = (DBManager.getSharedInstance()?.find(byAvBackgrounds: "\(dic.value(forKey: "category")!)", backgroundCategory: "1"))!
                let dic_type = arr_Type.object(at: 0) as! NSDictionary
                vc.dic_Type = dic_type
            }
            
        }
        else {
            arr_Type = (DBManager.getSharedInstance()?.find(byAvBackgrounds: "\(dic.value(forKey: "code")!)", backgroundCategory: "1"))!
            let dic_type = arr_Type.object(at: 0) as! NSDictionary
            vc.dic_Type = dic_type
        }
        vc.dic_Info = dic
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (parent?.view.frame.width)!;
        let height : CGFloat = 201;
        let cellSize = CGSize(width: width, height: height);
        return cellSize;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //spacing between cells
        return 0;
    }
    
    func openTicket(ticketData : Ticket){
        selectedTicketData = ticketData;
        performSegue(withIdentifier: "TicketInfo", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let ticket = segue.destination as! SingleTicketController;
       // ticket.ticketData = self.selectedTicketData;
    }
    
}
