//
//  TipsyServer.swift
//  tipsy
//
//  Created by Ben Jones on 9/7/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit
import CoreLocation

class TipsyServer: NSObject {
    static let  baseUrl = "http://www.gettipsy.io/api/v1"
    
    
    class var sessionId:String{
        get{
            return UserDefaults.standard.string(forKey: "sessionId") ?? ""
        }
        set{
            let moreDefaults = [
                "sessionId" : newValue
                ] as [String : Any]
            UserDefaults.standard.register(defaults: moreDefaults)
        }
    }
    
    class var userLocation:CLLocationCoordinate2D{
        set{
            let moreDefaults = [
                "userLocationLat" : newValue.latitude,
                "userLocationLong" : newValue.longitude
                ] as [String : Any]
            UserDefaults.standard.register(defaults: moreDefaults)
        }
        get{
            return CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "userLocationLat"), longitude: UserDefaults.standard.double(forKey: "userLocationLong"))
        }
    }
    
    class func isUserLocationSet() -> Bool{
        return UserDefaults.standard.dictionaryRepresentation().keys.contains("userLocationLat")
    }
    
    class func actionsJsonData(billAmount: Double, tipPercent: Double) -> Data{
        var dataHash = [
            "billAmount":billAmount,
            "tipPercent":tipPercent
        ] as [String : Any]
        if(isUserLocationSet()){
            dataHash["lat"] = userLocation.latitude
            dataHash["long"] = userLocation.longitude
        }
        return try! JSONSerialization.data(withJSONObject: dataHash, options: .prettyPrinted)
    }
    
    class func fireAction(billAmount: Double, tipPercent: Double){
        if(sessionId != ""){

            if let url = URL(string: "\(baseUrl)/sessions/\(sessionId)/actions"){
                
                let request = NSMutableURLRequest(url:url)
                request.httpMethod = "POST";
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = actionsJsonData(billAmount: billAmount, tipPercent: tipPercent)
                
                
                let task = URLSession.shared.dataTask(with:request as URLRequest)
                task.resume()
            }
        }
    }
    
    class func initSession(){
        if let url = URL(string: "\(baseUrl)/sessions"){

            let request = NSMutableURLRequest(url:url)
            request.httpMethod = "POST";
            let task = URLSession.shared.dataTask(with:request as URLRequest){
                data, response, error in
                
                do {
                    
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        sessionId = convertedJsonIntoDict["sessionId"] as? String ?? ""
                        
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }

}
