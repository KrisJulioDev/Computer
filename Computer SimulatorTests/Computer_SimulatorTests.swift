//
//  Computer_SimulatorTests.swift
//  Computer SimulatorTests
//
//  Created by Kris Julio on 9/9/17.
//  Copyright © 2017 Tenten. All rights reserved.
//

import XCTest
import RxSwift
@testable import Computer_Simulator

class Computer_SimulatorTests: XCTestCase {
    
    let disposeBag = DisposeBag()
    let computer = Computer(numberOfAddresses: 100)
    var pointer = PRINT_TENTEN_BEGIN
    var instructions = [""]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        
        // reset values
        pointer = PRINT_TENTEN_BEGIN
        instructions = [""]
        
        super.tearDown()
    }
    
    func testNormalExecution() {
        instructions = ["MULT", "PRINT", "RET", "PUSH 1009", "PRINT", "PUSH 6", "PUSH 101", "PUSH 10", "CALL 50", "STOP"]
        self.executeTest()
    }
    
    func testInvalidInstruction() {
        instructions = ["Mil", "PRINT", "RET", "PUSH 1009", "PRINT", "PUSH 6", "PUSH 101", "PUSH 10", "CALL 50", "STOP"]
        self.executeTest()
    }
    
    func testMissingInstruction() {
        instructions = ["Mil", "PRINT", "RET", "PUSH 1009", "PRINT", "PUSH 6", "PUSH 101", "PUSH 10", "CALL 50"]
        self.executeTest()
    }
    
    func testNotANumber() {
        instructions = ["MULT", "PRINT", "RET", "PUSH 1oo9", "PRINT", "PUSH 6", "PUSH 101", "PUSH 10", "CALL 50", "STOP"]
        self.executeTest()
    }
    
    func executeTest() {
        Observable
            .just(instructions)
            .map({ instructions in
                for command in instructions {
                    self.computer.push(command, &self.pointer)
                    
                    if command == "RET" { self.pointer = MAIN_BEGIN }
                }
            }).flatMap({
                return Observable.just(try self.computer.execute())
            }).subscribe(onNext: { value in
                print("finishing execution...")
            }, onError: { error in
                print("execution stopped... error ", error.localizedDescription)
                //XCTFail(error.localizedDescription)
            }, onCompleted: {
                print("execution completed...")
            }, onDisposed: {
                print("observable disposed...")
            }).addDisposableTo(disposeBag)
    }
}
