//
//  ViewController.swift
//  Computer Simulator
//
//  Created by Kris Julio on 9/9/17.
//  Copyright © 2017 Tenten. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let computer = Computer(numberOfAddresses: 100)
        var pointer = PRINT_TENTEN_BEGIN
        
        computer.push("MULT", &pointer)
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
        }
    }

}

