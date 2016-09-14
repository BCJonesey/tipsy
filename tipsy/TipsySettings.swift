//
//  TipsySettings.swift
//  tipsy
//
//  Created by Ben Jones on 9/6/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit

class TipsySettings: NSObject {
    
    // Set up some sane defaults
    class func initUserSettings(){
        let defaultSettings = [
            "tipValues" : [15,18,20],
            "defaultTipIndex" : 0
            ] as [String : Any]
        UserDefaults.standard.register(defaults: defaultSettings)
        
    }
    
    // available tip values
    class var tipValues:[Double]{
        get{
            return UserDefaults.standard.array(forKey: "tipValues") as! [Double]
        }
        set{
            UserDefaults.standard.set(newValue, forKey: "tipValues")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var defaultTipIndex:Int{
        get{
            return UserDefaults.standard.integer(forKey: "defaultTipIndex")
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "defaultTipIndex");
            UserDefaults.standard.synchronize();
        }
    }
    
    class var sessionData:[String:Any]{
        get{
            return UserDefaults.standard.dictionary(forKey: "sessionData") ?? [:]
        }
        set{
            UserDefaults.standard.setValue(newValue, forKey: "sessionData");
            UserDefaults.standard.synchronize();
        }
    }
    
    
}
