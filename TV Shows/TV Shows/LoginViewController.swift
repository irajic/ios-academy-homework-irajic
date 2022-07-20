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
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        let newloginVC = HomeViewController()
        let navVC = UINavigationController(rootViewController: newloginVC)
        
        present(navVC, animated: true)
    }
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        let newregisterVC = HomeViewController()
        let navigationViewController = UINavigationController(rootViewController: newregisterVC)
        
        present(navigationViewController, animated: true)
    }
    
}
