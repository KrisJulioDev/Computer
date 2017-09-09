//
//  ViewController.swift
//  Computer Simulator
//
//  Created by Kris Julio on 9/9/17.
//  Copyright © 2017 Tenten. All rights reserved.
//

import UIKit
import RxSwift


/*  DISCLAIMER:
    I might missed something on the given instructions.
    Or probably haven't handled all the edge cases.
 
    Also :  On the instructions, for example "PUSH 1009"
            1009 is a string parsed to Int. I do that to avoid multiple parameters. command / value / pointer
            it can be simplified.
 */
class ViewController: UIViewController {

    // create our dispose bag, where observables are added and disposed if deallocated.
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // instantiate a Computer with 100 addresses
        let computer = Computer(numberOfAddresses: 100)
        
        // pointer starts at 50 from the instruction
        var pointer = PRINT_TENTEN_BEGIN

        // list all instructions provided
        let instructions = ["MULTIPLY", "PRINT", "RET", "PUSH 1009", "PRINT", "PUSH 6", "PUSH 101", "PUSH 10", "CALL 50", "STOP"]
        
        // this rx observable is unecessary. Just for demo on how rxswift works.
        /*  1: Convert instruction to observable.
            2: map instructions, iterate to all commands and push it to computer stack
            3: flatMap. just like map except it returns an observable value. 
                in this case it can either return InstructionError or continue to SubscribeNext
            4: do nothing after succesful executon. just print current process.
            5: print Error if there is
            6: computer execution is completed here, even if it receives error or not.
            7: do work here right after the observable is disposed.
         */
        Observable
            .just(instructions) // 1
            .map({ instructions in // 2
                for command in instructions {
                    computer.push(command, &pointer)
                    
                    // specialized condition for this sample project instructions.
                    if command == "RET" { pointer = MAIN_BEGIN }
                }
            }).flatMap({ // 3
                return Observable.just(try computer.execute())
            }).subscribe(onNext: { value in // 4
                print("finishing execution...")
            }, onError: { error in // 5
                print(error.localizedDescription)
            }, onCompleted: { // 5
                print("execution completed...")
            }, onDisposed: { // 7
                print("observable disposed...")
            }).addDisposableTo(disposeBag)
    }

}

// original instruction
/*computer.push("MULT", &pointer)
 computer.push("PRINT", &pointer)
 computer.push("RET", &pointer)
 
 pointer = MAIN_BEGIN
 
 computer.push("PUSH 1009", &pointer)
 computer.push("PRINT", &pointer)
 computer.push("PUSH 6", &pointer)
 computer.push("PUSH 101", &pointer)
 computer.push("PUSH 10", &pointer)
 computer.push("CALL 50", &pointer)
 computer.push("STOP", &pointer)
 
 do {
 try computer.execute()
 } catch {
 print(error.localizedDescription)
 }*/

