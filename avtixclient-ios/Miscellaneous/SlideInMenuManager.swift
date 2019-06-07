//
//  SlideInMenuManager.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 09/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

//  Manager class to manage the slide in menu, root view controllers should extend this class

class SlideInMenuManager : UIViewController {
    
    var slideInMenu : SlideInMenuController!;
    var slideMenuContainer : UIView!;
    var _dimmer : UIView!;
    var activeView : ActiveView!;
    private var slideDuration : TimeInterval = 0.25;
    
    func setUpSlideMenu(){
        slideInMenu = Bundle.main.loadNibNamed("SlideInMenu", owner: self, options: nil)?.first as? SlideInMenuController;
        self.addChild(slideInMenu);
        slideInMenu.activeView = self.activeView;
        slideMenuContainer.addSubview(slideInMenu.view);
        slideInMenu.view.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint.activate([
            slideInMenu.view.leadingAnchor.constraint(equalTo: slideMenuContainer.leadingAnchor, constant: 0),
            slideInMenu.view.trailingAnchor.constraint(equalTo: slideMenuContainer.trailingAnchor, constant: 0),
            slideInMenu.view.topAnchor.constraint(equalTo: slideMenuContainer.topAnchor, constant: 0),
            slideInMenu.view.bottomAnchor.constraint(equalTo: slideMenuContainer.bottomAnchor, constant: 0)
            ]);
        slideInMenu.didMove(toParent: self);
    }
    
    @IBAction func toggleSlideInMenu(_ sender: Any) {
        
        var constraint : NSLayoutConstraint!;
        var alpha : CGFloat = 0.0;
        
        for temp in self.view.constraints{
            if(temp.identifier == "slideMenuContainerLeading"){
                constraint = temp;
                break;
            }
        }
        
        if(slideInMenu?.opened == true){
            constraint.constant = -302;
            alpha = 0.0;
        } else {
            constraint.constant = 0;
            alpha = 0.5;
        }
        
        UIView.animate(withDuration: slideDuration, animations: {
            self.view.layoutIfNeeded();
            self._dimmer.alpha = alpha;
        });
        slideInMenu?.opened = !(slideInMenu?.opened)!;
    }
}
