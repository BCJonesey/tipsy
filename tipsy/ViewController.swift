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
    
    
    let currencyFormatter = NumberFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        TipsyUtils.createTipSegmentedControl(control: tipSegmentedControl)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func calculateTip(_ sender: AnyObject) {

        let bill = Double(billField.text!) ?? 0 //getAndFormatBill()
        let tipPercent = TipsySettings.tipValues[tipSegmentedControl.selectedSegmentIndex]
        let tip = bill * (tipPercent/100)
        let total = bill + tip
        
        TipsyServer.fireAction(billAmount: bill, tipPercent: tipPercent)
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        
        
    }
    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        TipsyUtils.updateTipSegmentedControl(control: tipSegmentedControl)
    }
    
    
    /*
    func getAndFormatBill() -> Double{
        
        var strVal = billField.text!.replacingOccurrences(of: "$", with: "")
        
        let index = strVal.characters.index(of: ".")

        
        // this will happen if the value is 0.00 or similar
        if(index != nil){
            let extraDigits = strVal.distance(from: index!, to: strVal.endIndex) - 3
            print(extraDigits)
            if(extraDigits < 0){
                strVal = strVal.replacingCharacters(in: <#T##Range<Index>#>, with: <#T##String#>)
                billVal = (billVal.floatValue / 10) as NSNumber
            }else if(extraDigits > 0){
                billVal = (billVal.floatValue * 10) as NSNumber
            }
            
        }
        
        
        billField.text = currencyFormatter.string(from: billVal)
        return billVal as Double
    }
    */
}

