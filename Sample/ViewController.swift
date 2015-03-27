//
//  ViewController.swift
//  Sample
//
//  Created by Rogelio Gudino on 3/26/15.
//  Copyright (c) 2015 Rogelio Gudino. All rights reserved.
//

import UIKit
import LittleConsole

class ViewController: UIViewController {
    @IBOutlet var logButton: UIButton?
    var counter = 1
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        LittleConsole.show()
    }
    
    @IBAction func logButtonWasPressed(sender: UIButton) {
        LittleConsole.log("Message \(self.counter)!")
        self.counter++
    }
}
