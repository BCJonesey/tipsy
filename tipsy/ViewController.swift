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
        let tipPercentages = [0.15,0.18,0.2]
        let bill = Double(billField.text!) ?? 0
        let tip = bill * tipPercentages[tipSegmentedControl.selectedSegmentIndex]
        let total = bill + tip
        
        
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
}

