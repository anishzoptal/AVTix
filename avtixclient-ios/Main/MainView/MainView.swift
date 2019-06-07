//
//  MainEventListView.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 03/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

class MainView: SlideInMenuManager {
    
    @IBOutlet var tabCollection: UICollectionView!
    @IBOutlet var tabMenuCollection: UICollectionView!
    var tabMenuManager : TabMenuCollection?;
    var tabManager : TabCollection?;
    
    @IBOutlet var slideMenuView: UIView!
    @IBOutlet var dimmerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setUpTabs();
        _dimmer = dimmerView;
        slideMenuContainer = slideMenuView;
        activeView = ActiveView.HOME;
        setUpSlideMenu();
    }
    
    func setUpTabs(){
        tabMenuManager = TabMenuCollection(_collection: tabMenuCollection);
        tabManager = TabCollection(_collection: tabCollection);
        tabMenuManager?.tabManager = self.tabManager;
        tabManager?.tabMenuManager = self.tabMenuManager;
    }
}
