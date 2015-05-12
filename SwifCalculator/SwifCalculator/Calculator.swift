//
//  Calculator.swift
//  SwifCalculator
//
//  Created by Adam Ahrens on 5/11/15.
//  Copyright (c) 2015 Adam Ahrens. All rights reserved.
//

import Foundation

class Calculator {
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Operation)
        case BinaryOperation(String, Operation)
        
        var description: String {
            get {
                switch self {
                    case .Operand(let number) : return "\(number)"
                    case .UnaryOperation(let mathSymbol, let op): return mathSymbol
                    case .BinaryOperation(let mathSymbol, let op): return mathSymbol
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
        allowedOps["+"] = Op.BinaryOperation("+", Operation.Binary(operation: +))
        allowedOps["-"] = Op.BinaryOperation("-", Operation.Binary(operation: { $1 - $0 }))
        allowedOps["×"] = Op.BinaryOperation("×", Operation.Binary(operation: *))
        allowedOps["÷"] = Op.BinaryOperation("+", Operation.Binary(operation: { $1 / $0 }))
        allowedOps["√"] = Op.UnaryOperation("√", Operation.Unary(operation: sqrt))
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
    
    //MARK: Private Methods
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
                        switch operation {
                            case .Unary(let theOp) :
                                return (theOp(number), evaluation.remaining)
                            case .Binary : break
                        }
                    }
                case .BinaryOperation(_, let operation) :
                    let firstEvaluation = evaluate(remainingOps)
                    if let number = firstEvaluation.result {
                        let secondEvaluation = evaluate(firstEvaluation.remaining)
                        if let nextNumber = secondEvaluation.result {
                            switch operation {
                                case .Binary(let theOp) :
                                    return (theOp(number, nextNumber), secondEvaluation.remaining)
                                case .Unary : break
                            }
                        }
                    }
            }
        }
        
        // Failure
        return (nil, ops)
    }
    
}
