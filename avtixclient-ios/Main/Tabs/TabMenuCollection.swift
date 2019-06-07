//
//  TabMenuCollection.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 04/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

//  This is a collection of event list NAMES

import Foundation
import UIKit

class TabMenuCollection: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    let menuItemWidth = 180;
    var menuCollection : UICollectionView! = nil;
    var tabManager : TabCollection!;
    
    var selectedCell : TabMenuItem!;
    var selectedIndex : Int = 0;
    var arr_AvCategoriesData = NSArray()
    
    
    init(_collection : UICollectionView){
        super.init();
        arr_AvCategoriesData = (DBManager.getSharedInstance()?.find(byAvCategories: "") )!
        //EventData.data.tabs = arr_AvEventData as! [String]
        print("==============\(arr_AvCategoriesData)")
        menuCollection = _collection;
        menuCollection.delegate = self;
        menuCollection.dataSource = self;
        let tabNib = UINib(nibName: "TabMenuItem", bundle: nil);
        menuCollection.register(tabNib, forCellWithReuseIdentifier: "tabMenuItem");
        menuCollection.reloadData();
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_AvCategoriesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabMenuItem", for: indexPath as IndexPath) as! TabMenuItem;
        let dic = arr_AvCategoriesData.object(at: indexPath.row) as! NSDictionary
        let str = dic.value(forKey: "name") as! String
        
        cell.tabName.text = str.uppercased()
        if(selectedIndex == indexPath.item){
            selectedCell = cell;
            cell.indicatorBar.isHidden = false;
            cell.isSelected = true;
        }else {
            cell.indicatorBar.isHidden = true;
            cell.isSelected = false;
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        menuCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true);
        selectedIndex = indexPath.item;
        selectedCell.indicatorBar.isHidden = true;
        selectedCell.isSelected = false;
        selectedCell = (menuCollection.cellForItem(at: indexPath) as! TabMenuItem);
        selectedCell.indicatorBar.isHidden = false;
        tabManager.scrollToPosition(index: indexPath);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = collectionView.frame.height;
        return CGSize(width: menuItemWidth, height: Int(itemHeight));
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func scrollToPosition(index : IndexPath) {
        menuCollection.scrollToItem(at: index, at: .centeredHorizontally, animated: true);
        selectedIndex = index.item;
        selectedCell.indicatorBar.isHidden = true;
        selectedCell.isSelected = false;
        guard let cell = menuCollection.cellForItem(at: index) else { return }
        selectedCell = (cell as! TabMenuItem)
        selectedCell.indicatorBar.isHidden = false;
        selectedCell.isSelected = true;
    }
}
