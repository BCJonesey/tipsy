//
//  ViewController.swift
//  tipsy
//
//  Created by Ben Jones on 9/6/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipSegmentedControl: UISegmentedControl!
    @IBOutlet weak var averageTipLabel: UILabel!
    
    
    let currencyFormatter = NumberFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TipsyUtils.createTipSegmentedControl(control: tipSegmentedControl)
        
        billField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.sessionCreated), name: TipsyServer.SESSION_CREATED_NOTIFICATION, object: nil)
        
        
        TipsyServer.initSession()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        reDrawFields()
    }
    
    func reDrawFields(){
        let bill = getBill()
        let tipPercent = TipsySettings.tipValues[tipSegmentedControl.selectedSegmentIndex]
        let tip = bill * (tipPercent/100)
        let total = bill + tip
        
        TipsyServer.fireAction(billAmount: bill, tipPercent: tipPercent)
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reDrawFields()
        TipsyUtils.updateTipSegmentedControl(control: tipSegmentedControl)
    }
    
    
    
    func getBill() -> Double{
        
        var strVal = billField.text!.replacingOccurrences(of: "$", with: "")
        
        if(strVal.characters.count < 1){
            billField.text = "$"
            return Double(0)
        }
        
        return Double(strVal) ?? 0
    }
    
    
    func sessionCreated(notification:Notification){
        print(notification.userInfo)
        if let info = notification.userInfo as? Dictionary<String,Any> {
            // Check if value present before using it
            if(info["averageTip"] != nil) {
                DispatchQueue.main.async {
                    self.setAverageTipText(averageTip: info["averageTip"] as? Double ?? 0)
                }
            }
            if(info["oldBill"] != nil) {
                DispatchQueue.main.async {
                    self.rememberOldBill(oldBill: info["oldBill"] as? Double ?? 0)
                }
            }
            if(info["tipPercentage"] != nil) {
                DispatchQueue.main.async {
                    self.rememberTip(tip: info["tipPercentage"] as? Double ?? 0)
                }
            }
        }
        
    }
    func rememberTip(tip: Double){
        if(tip > 0){
            tipSegmentedControl.selectedSegmentIndex = TipsySettings.tipValues.index(of: tip) ?? TipsySettings.defaultTipIndex
            reDrawFields()
        }
    }
    
    func rememberOldBill(oldBill: Double){
        if(oldBill > 0 && billField.text == "$"){
            billField.text = String(format:"$%.2f",oldBill)
            reDrawFields()
        }
    }
    
    func setAverageTipText(averageTip:Double){
        if(averageTip > 0){
            averageTipLabel.text = String(format: "The average tip is %.1f%% here.", averageTip)
        }
    }
    
}

