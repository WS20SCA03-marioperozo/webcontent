//
//  SecondViewController.swift
//  webcontent
//
//  Created by Mario Perozo on 6/1/20.
//  Copyright © 2020 Mario Perozo. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    var transferredPrice: String? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        label.text = String(format: "The price of the stock is US$ %.2f.", price);
        
        label.text = "The price of the stock is US$ \(transferredPrice!)";
        
        
    }
}
