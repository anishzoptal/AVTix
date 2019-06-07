//
//  TabCollection.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 04/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

//  This is a collection of lists of events

import Foundation
import UIKit

class TabCollection : NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    var tabCollection : UICollectionView!;
    var tabMenuManager : TabMenuCollection!;
    var arr_AvCategoriesData = NSArray()
    
    init(_collection : UICollectionView){
        super.init();
        arr_AvCategoriesData = (DBManager.getSharedInstance()?.find(byAvCategories: "") )!
        //EventData.data.tabs = arr_AvEventData as! [String]
        print("==============\(arr_AvCategoriesData)")
        tabCollection = _collection;
        let tabNib = UINib(nibName: "EventsTableView", bundle: nil);
        tabCollection.register(tabNib, forCellWithReuseIdentifier: "tabCell");
        tabCollection.delegate = self;
        tabCollection.dataSource = self;
        tabCollection.reloadData();
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_AvCategoriesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tabCollection.dequeueReusableCell(withReuseIdentifier: "tabCell", for: indexPath as IndexPath) as! EventsTableView;
        
        let dic = arr_AvCategoriesData.object(at: indexPath.row) as! NSDictionary
        let str = dic.value(forKey: "name") as! String
        cell.tabFunction = str.uppercased()
       
        cell.displayData();
        return cell;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(tabCollection.contentOffset.x / tabCollection.frame.size.width);
        tabMenuManager.scrollToPosition(index: IndexPath(row: index, section: 0));
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return tabCollection.frame.size;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    
    func scrollToPosition(index : IndexPath){
        tabCollection.scrollToItem(at: index, at: .right, animated: true);
    }
}
