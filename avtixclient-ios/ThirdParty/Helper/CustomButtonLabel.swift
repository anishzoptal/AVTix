
//
//  CustomButtonLabel.swift
//  avtixclient-ios
//
//  Created by eshan Cheema on 03/06/19.
//  Copyright © 2019 avtixclient-ios. All rights reserved.
//

import Foundation
public class LocalizeButton: UIButton {
    //MARK: - Awake from nib -
    public override func awakeFromNib() {
        localize()
    }
    // MARK: Overrides
    override public func layoutSubviews() {
        super.layoutSubviews()
        localize()
    }
    func localize() {
        if let title = self.titleLabel?.text {
            self.setTitle(title.localizedKey(), for: .normal)
        }
    }
}

public class LocalizeLabel: UILabel {
    //MARK: - Awake from nib -
    public override func awakeFromNib() {
        localize()
    }
    // MARK: Overrides
    override public func layoutSubviews() {
        super.layoutSubviews()
        localize()
    }
    func localize() {
        if let title = self.text {
            self.text = title.localizedKey()
        }
    }
}
