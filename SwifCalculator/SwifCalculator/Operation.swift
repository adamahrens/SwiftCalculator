//
//  Operation.swift
//  SwifCalculator
//
//  Created by Adam Ahrens on 5/11/15.
//  Copyright (c) 2015 Adam Ahrens. All rights reserved.
//

enum Operation {
    case Unary(operation: (Double) -> Double)
    case Binary(operation: (Double, Double) -> Double)
}