//
//  Calculator.swift
//  SwifCalculator
//
//  Created by Adam Ahrens on 5/11/15.
//  Copyright (c) 2015 Adam Ahrens. All rights reserved.
//

import Foundation

class Calculator {
    typealias SingleOperation = (Double) -> Double
    typealias DoubleOperation = (Double, Double) -> Double
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, SingleOperation)
        case BinaryOperation(String, DoubleOperation)
        
        var description: String {
            get {
                switch self {
                    case .Operand(let number) : return "\(number)"
                    case .UnaryOperation(let mathSymbol, _): return mathSymbol
                    case .BinaryOperation(let mathSymbol, _): return mathSymbol
                }
            }
        }
    }
    
    //MARK: Private vars
    private var opStack = [Op]()
    private var allowedOps = [String: Op]()
    
    //MARK: Init
    init() {
        // Can just pass the + function name
        //allowedOps["+"] = Op.BinaryOperation("+", Operation.Binary(operation: { $0 + $1 }))
        allowedOps["+"] = Op.BinaryOperation("+", +)
        allowedOps["-"] = Op.BinaryOperation("-") { $1 - $0 }
        allowedOps["×"] = Op.BinaryOperation("×", *)
        allowedOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        allowedOps["√"] = Op.UnaryOperation("√", sqrt)
        allowedOps["cos"] = Op.UnaryOperation("cos", cos)
        allowedOps["sin"] = Op.UnaryOperation("sin", sin)
    }
    
    //MARK: Public Methods
    func pushOperand(operand: Double) -> Double?  {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(mathSymbol: String) -> Double? {
        if let operation = allowedOps[mathSymbol] {
            opStack.append(operation)
            return evaluate()
        }
        
        return nil
    }
    
    func evaluate() -> Double? {
        let (result, _) = evaluate(opStack)
        return result
    }
    
    func reset() {
        opStack = [Op]()
    }
    
    func history() -> String? {
        if !opStack.isEmpty {
            return history(opStack)
        }
        
        // No elements to display
        return nil
    }
    
    //MARK: Private Methods
    private func history(ops: [Op], currentHistoryDisplay: String? = nil) -> String? {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            let currentHistory = currentHistoryDisplay ?? ""
            switch op {
                case .Operand(let number) : return remainingOps.isEmpty ? history(remainingOps, currentHistoryDisplay: currentHistory + "\(number)") : history(remainingOps, currentHistoryDisplay: currentHistory + "\(number) -- ")
                case .UnaryOperation:
                    let evaluation = evaluate(remainingOps)
                    if let number = evaluation.result {
                        remainingOps.removeLast()
                        return remainingOps.isEmpty ? history(remainingOps, currentHistoryDisplay : "\(currentHistory) \(op)(\(number))") : history(remainingOps, currentHistoryDisplay : "\(currentHistory) \(op)(\(number)) -- ")
                    }
                case .BinaryOperation :
                    let firstEvaluation = evaluate(remainingOps)
                    if let number = firstEvaluation.result {
                        let secondEvaluation = evaluate(firstEvaluation.remaining)
                        if let nextNumber = secondEvaluation.result {
                            // Pop off the two other numbers
                            remainingOps.removeLast()
                            remainingOps.removeLast()
                            return remainingOps.isEmpty ? history(remainingOps, currentHistoryDisplay: "\(currentHistory) \(number) \(op) \(nextNumber)") : history(remainingOps, currentHistoryDisplay: "\(currentHistory) \(number) \(op) \(nextNumber) -- ")
                        }
                    }
            }
        }
        
        return currentHistoryDisplay
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remaining: [Op]) {
        // Recursion
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
                case .Operand(let number) : return (number, remainingOps)
                case .UnaryOperation(_, let operation) :
                    let evaluation = evaluate(remainingOps)
                    if let number = evaluation.result {
                        return (operation(number), evaluation.remaining)
                    }
                case .BinaryOperation(_, let operation) :
                    let firstEvaluation = evaluate(remainingOps)
                    if let number = firstEvaluation.result {
                        let secondEvaluation = evaluate(firstEvaluation.remaining)
                        if let nextNumber = secondEvaluation.result {
                            return (operation(number, nextNumber), secondEvaluation.remaining)
                        }
                    }
            }
        }
        
        // Failure
        return (nil, ops)
    }
}
