//
//  RestTimerView.swift
//  Productivity2
//
//  Created by Kim on 09/07/15.
//  Copyright (c) 2015 Kim. All rights reserved.
//

import UIKit

@objc class RestTimerView: UIView {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var tapToCloseLabel: UILabel!
    
    @objc class func instanceFromNib() -> RestTimerView {
        return UINib(nibName: "RestTimerView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! RestTimerView
    }
    
    func setUI() {
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowRadius = 2.0;
        self.layer.shadowOpacity = 0.4;
        self.layer.shadowColor = UIColor.blackColor().CGColor;
        self.layer.borderWidth = 1.5;
        self.layer.borderColor = UIColor.blackColor().CGColor;
        self.layer.cornerRadius = 20.0;
    }
}
