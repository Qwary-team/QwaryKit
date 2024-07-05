//
//  ViewController.swift
//  QwaryKit
//
//  Created by vishal@qwary.com on 07/05/2024.
//  Copyright (c) 2024 vishal@qwary.com. All rights reserved.
//

import UIKit
import QwaryKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Qwary.configure(context: self, qwSettings: "App_Id")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

