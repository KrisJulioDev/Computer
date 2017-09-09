//
//  Computer.swift
//  Computer Simulator
//
//  Created by Kris Julio on 9/9/17.
//  Copyright © 2017 Tenten. All rights reserved.
//

import UIKit

enum InstructionError: Error {
    case NilValueFound(Int)
    case NotANumber(Int)
    case EmptyInstructions(Int)
    case NotAValidInstruction(Int)
}

extension InstructionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        
        case .NilValueFound(let ptr):
            return "Nil value found. Exiting program at address \(ptr)...."
        case .NotANumber(let ptr):
            return "Expecting a number. Exiting program at address \(ptr)...."
        case .EmptyInstructions(let ptr):
            return "Instruction not found. Exiting program at address \(ptr)...."
        case .NotAValidInstruction(let ptr):
            return "Not a valid instruction. Exiting program at address \(ptr)...."
        }
    }
}

class Computer {
    
    // swift dont have stack collection type, create our own.
    var memory = Stack()
    
    var addressCount: Int
    
    // execution always starts at address 0
    var currentMemoryAddress = 0
    
    // initialize the addresses only when needed and to assure addressCount has value.
    lazy var addresses: [String?] = {
        return [String?](repeating: nil, count: self.addressCount)
    }()
    
    
    init(numberOfAddresses: Int = 100) {
        addressCount = numberOfAddresses
    }
    
    // function for adding computer instructions
    // params: command -> Instructions like PUSH, PRINT, CALL, STOP etc.
    // params: address -> memory address of instruction
    func push(_ command: String?, _ address: inout Int) {
        addresses[address] = command
        address += 1
    }
    
    //TODO: Command instructions are case sensitive, only supports all caps
    func execute() throws {
        
        while true {
            
            // command starts
            let command = addresses[currentMemoryAddress]
            
            guard command != nil else { throw InstructionError.EmptyInstructions(currentMemoryAddress) }
            
            if (command?.hasPrefix("PUSH"))! {
                try push(command: command!)
            } else if (command?.hasPrefix("PRINT"))! {
                print()
            } else if (command?.hasPrefix("MULT"))! {
                try multiply(command: command!)
            } else if (command?.hasPrefix("RET"))! {
                try returnToAddress()
            } else if (command?.hasPrefix("CALL"))! {
                try call(command: command!)
            } else if (command?.hasPrefix("STOP"))! {
                debugPrint("Execution completed...")
                break
            } else {
                throw InstructionError.NotAValidInstruction(currentMemoryAddress)
            }
        }
    }
    
    private func incrementAddress(by value: Int = 1) {
        currentMemoryAddress += value
    }
    
    private func push(command: String) throws {
        let value = command.components(separatedBy: " ").last.map({ Int($0) })
        
        guard value != nil else { throw InstructionError.NilValueFound(currentMemoryAddress) }
        guard value is Int else { throw InstructionError.NotANumber(currentMemoryAddress) }
        
        memory.push(value!!)
        incrementAddress()
        
    }
    
    private func print() {
        let value = memory.pop()
        debugPrint(value ?? "")
        incrementAddress()
    }
    
    private func call(command: String) throws {
        let  value = command.components(separatedBy: " ").last.map({ Int($0)})
        
        guard value != nil else { throw InstructionError.NilValueFound(currentMemoryAddress) }
        guard value is Int else { throw InstructionError.NotANumber(currentMemoryAddress) }
        
        currentMemoryAddress = value!!
    }
    
    private func multiply(command: String) throws {
        let firstOperand = memory.pop()
        let secondOperand = memory.pop()
        
        guard firstOperand != nil else { throw InstructionError.NilValueFound(currentMemoryAddress) }
        guard secondOperand != nil else { throw InstructionError.NilValueFound(currentMemoryAddress) }
        
        let product = firstOperand! * secondOperand!
        memory.push(product)
        incrementAddress()
    }
    
    private func returnToAddress() throws {
        let value = memory.pop()
        
        guard value != nil else { throw InstructionError.NilValueFound(currentMemoryAddress) }
        currentMemoryAddress = value!
    }
}
