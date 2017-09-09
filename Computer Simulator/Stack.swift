//
//  Stack.swift
//  Computer Simulator
//
//  Created by Kris Julio on 9/9/17.
//  Copyright © 2017 Tenten. All rights reserved.
//

import UIKit

// Basic implementation of stack
class Stack { 
    var stackArray = [Int]()
    
    func push(_ element: Int) {
        stackArray.append(element)
    }
    
    func pop() -> Int? {
        return stackArray.popLast()
    }
}
