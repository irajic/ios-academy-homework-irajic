//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 7/19/22.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: -Outlet
    
    // MARK: -Lifecycle methodes
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: -Methodes
    
    // MARK: -Actions
    
    @IBAction func checkButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}
