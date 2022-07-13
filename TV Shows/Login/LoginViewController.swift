//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 7/13/22.
//

var numberOfClicks = 0

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func ButtonActionHendler(_ sender: Any) {
        print("Click, click")
        numberOfClicks+=1
        self.LabelOutlet.text = "\(numberOfClicks)"
        
    }
    
    @IBOutlet weak var LabelOutlet: UILabel!
    
}
