//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 7/19/22.
//

import UIKit
import MBProgressHUD
import Alamofire

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
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        navigationController?.pushViewController(homeViewController, animated: true)
        
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        navigationController?.pushViewController(homeViewController, animated: true)
        
    }
    
    
}
