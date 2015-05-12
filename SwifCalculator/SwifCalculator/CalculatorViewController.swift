//
//  CalculatorViewController.swift
//  SwifCalculator
//
//  Created by Adam Ahrens on 5/6/15.
//  Copyright (c) 2015 Adam Ahrens. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var calculatorDisplay: UILabel! // Automatic unwrapping the optional
    
    //MARK: Private vars
    private var userIsTypingNumber = false
    private let brain = Calculator()
    
    //MARK: Computed Property
    private var calculatorDisplayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(calculatorDisplay.text!)!.doubleValue
        }
        set {
            userIsTypingNumber = false
            calculatorDisplay.text = "\(newValue)"
        }
    }
    
    //MARK: IBActions
    @IBAction func numberPressed(sender: UIButton) {
        let number = sender.currentTitle!
        if userIsTypingNumber {
            let updatedDisplay = calculatorDisplay.text! + number
            calculatorDisplay.text = updatedDisplay
        } else {
            userIsTypingNumber = true
            calculatorDisplay.text = number
        }
    }
    
    @IBAction func operationPressed(sender: UIButton) {
        if let operation = sender.currentTitle {
            if userIsTypingNumber {
                enterPressed()
            }
            
            if let result = brain.performOperation(operation) {
                calculatorDisplayValue = result
            } else {
                calculatorDisplayValue = 0
            }
        }
    }
    
    @IBAction func enterPressed() {
        userIsTypingNumber = false
        if let result = brain.pushOperand(calculatorDisplayValue) {
            calculatorDisplayValue = result
        } else {
            calculatorDisplayValue = 0
        }
    }
    
    @IBAction func clearPressed(sender: UIButton) {
        userIsTypingNumber = false
        calculatorDisplay.text = "0"
    }
}

