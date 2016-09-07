//
//  SettingsViewController.swift
//  tipsy
//
//  Created by Ben Jones on 9/6/16.
//  Copyright © 2016 Ben Jones. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var highTipTextField: UITextField!
    @IBOutlet weak var medTipTextField: UITextField!
    @IBOutlet weak var defaultTipSegmentedControl: UISegmentedControl!
    @IBOutlet weak var lowTipTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TipsyUtils.createTipSegmentedControl(control: defaultTipSegmentedControl)
        highTipTextField.text = String(format: "%g", TipsySettings.tipValues[2])
        medTipTextField.text = String(format: "%g", TipsySettings.tipValues[1])
        lowTipTextField.text = String(format: "%g", TipsySettings.tipValues[0])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func defaultTipChanged(_ sender: AnyObject) {
        TipsySettings.defaultTipIndex = defaultTipSegmentedControl.selectedSegmentIndex
    }

    @IBAction func tipsChanged(_ sender: AnyObject) {
        var tipArray = TipsySettings.tipValues
        let val = Double(sender.text!) ?? 0
        if(sender as! NSObject == highTipTextField){
           tipArray[2] = val
        }else if(sender as! NSObject == medTipTextField){
            tipArray[1] = val
        }else if(sender as! NSObject == lowTipTextField){
            tipArray[0] = val
        }
        TipsySettings.tipValues = tipArray
        TipsyUtils.updateTipSegmentedControl(control: defaultTipSegmentedControl)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
