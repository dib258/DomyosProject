//
//  RadioButtons.swift
//  DomyosProject
//
//  Created by Gilles Major on 25/03/15.
//  Copyright (c) 2015 258labs. All rights reserved.
//

import UIKit

class RadioButtons: UIControl {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let nib = NSBundle.mainBundle().loadNibNamed("RadioButtons", owner: self, options: nil)
        let view = nib.first as UIView
        self.addSubview(view)
    }

}
