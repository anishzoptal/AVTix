//
//  AboutData.swift
//  avtixclient-ios
//
//  Created by Andro Mikulić on 15/10/2018.
//  Copyright © 2018 avtixclient-ios. All rights reserved.
//

import Foundation
import UIKit

class AboutData : UIView {
    
    @IBOutlet var logo: UIImageView!
    
    func aboutDataContentSize() -> CGFloat {
        let offset = logo.frame.origin.y + logo.frame.height + 8;
        return offset;
    }
}
