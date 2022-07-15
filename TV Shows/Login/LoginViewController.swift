//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 7/15/22.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private var numberOfTaps:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func buttonAction(_ sender: Any) {
        numberOfTaps+=1
        self.labelOutlet.text="\(numberOfTaps)"
    }
    
    @IBOutlet weak var labelOutlet: UILabel!
    
}
