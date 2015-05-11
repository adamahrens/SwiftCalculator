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
    private var operandStack = [Double]()
    
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
            
            switch operation {
                case "+" : performOperation { $0 + $1 }
                case "-" : performOperation { $1 - $0 }
                case "×" : performOperation { $0 * $1 }
                case "÷" : performOperation { $1 / $0 }
                default : break
            }
        }
    }
    
    @IBAction func enterPressed() {
        userIsTypingNumber = false
        operandStack.append(calculatorDisplayValue)
    }
    
    @IBAction func clearPressed(sender: UIButton) {
        userIsTypingNumber = false
        calculatorDisplay.text = "0"
        operandStack.removeAll(keepCapacity: false)
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            calculatorDisplayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enterPressed()
        }
    }
}

