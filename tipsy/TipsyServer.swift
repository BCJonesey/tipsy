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
    // Location of the Tipsy API
    static let  baseUrl = "http://www.gettipsy.io/api/v1"
    
    // The name of the event that gets fired when the session is available
    static let SESSION_CREATED_NOTIFICATION = NSNotification.Name(rawValue: "com.Tipsy.TipsySessionCreated")
    
    
    // The ID of the current session
    class var sessionId:String{
        get{
            if(TipsySettings.sessionData["sessionId"] != nil){
                return TipsySettings.sessionData["sessionId"] as? String ?? ""
            }else{
                return ""
            }
            
        }
        set{
            updateSession(sessionId: newValue, billAmout: nil, tipPercentage: nil, averageTip: nil)
        }
    }
    
    // The user location for the current session
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
    
    // Determines if the user location is available for this session
    class func isUserLocationSet() -> Bool{
        return UserDefaults.standard.dictionaryRepresentation().keys.contains("userLocationLat")
    }
    
    
    // Puts together the JSON data for a standard tipsy post request
    class func requestJsonData(additionalData: [String:Any]) -> Data{
        
        var dataHash = additionalData
        if(isUserLocationSet()){
            dataHash["lat"] = userLocation.latitude
            dataHash["long"] = userLocation.longitude
        }
        return try! JSONSerialization.data(withJSONObject: dataHash, options: .prettyPrinted)
    }
    
    // let the server know that the user took an action
    class func fireAction(billAmount: Double, tipPercent: Double){
        if(sessionId != ""){
            
            updateSession(sessionId: nil, billAmout: billAmount, tipPercentage: tipPercent, averageTip: nil)
            print(sessionId)
            if let url = URL(string: "\(baseUrl)/sessions/\(sessionId)/actions"){
                
                let request = NSMutableURLRequest(url:url)
                request.httpMethod = "POST";
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = requestJsonData(additionalData: ["billAmount": billAmount, "tipPercent": tipPercent])
                
                
                let task = URLSession.shared.dataTask(with:request as URLRequest)
                task.resume()
            }
        }
    }
    
    // Set up a session for this app start
    class func initSession(){
        // Check to see if we can use a stored session
        if(isSessionStillFresh()) {
            // Pull infor from stored session
            let averageTip = TipsySettings.sessionData["averageTip"] as? Double
            let oldBill = TipsySettings.sessionData["billAmout"] as? Double
            let tipPercentage = TipsySettings.sessionData["tipPercentage"] as? Double
            
            // Let people know that we are ready to go
            NotificationCenter.default.post(name: SESSION_CREATED_NOTIFICATION, object: self, userInfo: ["averageTip":averageTip, "oldBill": oldBill, "tipPercentage": tipPercentage])
        }// If there is no vaild stored session, we need to get one from the server
        else if let url = URL(string: "\(baseUrl)/sessions"){
            let request = NSMutableURLRequest(url:url)
            request.httpMethod = "POST";
            let task = URLSession.shared.dataTask(with:request as URLRequest){
                data, response, error in
                if(data != nil){
                    do {
                        
                        if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            // Get the deets from the server response
                            let sessionId = convertedJsonIntoDict["sessionId"] as? String ?? ""
                            let averageTip = convertedJsonIntoDict["averageTip"] as? Double ?? 0
                            updateSession(sessionId: sessionId, billAmout: nil, tipPercentage: nil, averageTip: averageTip)
                            // we are ready to go!
                            NotificationCenter.default.post(name: SESSION_CREATED_NOTIFICATION, object: self, userInfo: ["averageTip":averageTip])
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
    }
    
    // Determines if we have a saved session that we can use
    // The session is fresh if it has existed for less than 10 min
    class func isSessionStillFresh() -> Bool {
        if(sessionId != "" && TipsySettings.sessionData["updateTime"] != nil  &&  NSDate().timeIntervalSince(TipsySettings.sessionData["updateTime"] as! Date) < 600){
            return true
        }else{
            TipsySettings.sessionData = [:]
            return false
        }
    }
    
    // Call if we make any changes so that we can acess it later if we need to
    class func updateSession(sessionId: String?, billAmout: Double?, tipPercentage: Double?, averageTip: Double?){
        var newSession = TipsySettings.sessionData
        
        if(sessionId != nil){
            newSession["sessionId"] = sessionId
        }
        if(billAmout != nil){
            newSession["billAmout"] = billAmout
        }
        if(tipPercentage != nil){
            newSession["tipPercentage"] = tipPercentage
        }
        if(averageTip != nil){
            newSession["averageTip"] = averageTip
        }
        newSession["updateTime"] = NSDate()
        
        print("update session")
        print(newSession)
        
        TipsySettings.sessionData = newSession
    }
    
}
