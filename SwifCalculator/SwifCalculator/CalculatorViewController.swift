//
//  CalculatorViewController.swift
//  SwifCalculator
//
//  Created by Adam Ahrens on 5/6/15.
//  Copyright (c) 2015 Adam Ahrens. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var calculatorDisplay: UILabel!
    
    @IBAction func numberPressed(sender: UIButton) {
        let number = sender.currentTitle!
        if calculatorDisplay.text == "0" {
            calculatorDisplay.text = number
        } else {
            let updatedDisplay = calculatorDisplay.text! + number
            calculatorDisplay.text = updatedDisplay
        }
    }
    
    @IBAction func clearPressed(sender: UIButton) {
        calculatorDisplay.text = "0"
    }
}

