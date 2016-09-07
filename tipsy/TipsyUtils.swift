//
//  TipsyUtils.swift
//  tipsy
//
//  Created by Ben Jones on 9/6/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit

class TipsyUtils: NSObject {
    
    class func createTipSegmentedControl(control:UISegmentedControl){
        control.removeAllSegments()
        for tip in TipsySettings.tipValues{
            control.insertSegment(withTitle: String(format: "%g%%", tip), at: control.numberOfSegments, animated: false)
        }
        control.selectedSegmentIndex = TipsySettings.defaultTipIndex
        
    }
    
    class func updateTipSegmentedControl(control:UISegmentedControl){
        let selectedIndex = control.selectedSegmentIndex
        TipsyUtils.createTipSegmentedControl(control: control)
        control.selectedSegmentIndex = selectedIndex
        
    }

}
