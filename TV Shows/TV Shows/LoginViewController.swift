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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: -Lifecycle methodes
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: -Methodes
    
    // MARK: -Actions
    
    @IBAction func checkButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        
        let registerParameters: [String: String] = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!,
            "password_confirmation": passwordTextField.text!
        ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if emailTextField.text!.isEmpty {
            print("error")
        } else {
            AF
                .request ("https://tv-shows.infinum.academy/users",
                          method: HTTPMethod.post,
                          parameters: registerParameters,
                          encoder: JSONParameterEncoder.default
                )
                .responseJSON { [weak self] response in
                    guard let self = self else {
                        return
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                    switch response.result {
                    case .success(let userInfo):
                        let user = User(params: userInfo)
                        print(user?.email)
                    
                        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                        self.navigationController?.pushViewController(homeViewController, animated: true)
                    
                    case .failure(let error):
                        print(error)
                    }
                }
        }
}
    
@IBAction func loginUser(_ sender: Any) {
        
        let loginParameters: [String: String] = [
            "email": emailTextField.text!,
            "password": passwordTextField.text!
        ]
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        AF
            .request(
                "https://tv-shows.infinum.academy/users/sign_in",
                method: HTTPMethod.post,
                parameters: loginParameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseJSON { [weak self] response in
                guard let self = self else {
                    return
                }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch response.result {
                case .success(let userInfo):
                    let user = User(params: userInfo)
                    print(user?.email)
                    
                    let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
}

struct User {
    
    let email: String
    let id: String
    let image_url: String?
    
    init?(params: Any) {
        let dict = params as? [String: Any]
        let user = dict?["user"] as? [String: Any]
        let email = user?["email"] as? [String: Any]
        
        let parsedEmail = user?["email"] as? String
        let parsedId = user?["id"] as? String
        self.image_url = user? ["image_url"] as? String
        
        if let parsedEmail = parsedEmail, let parsedId = parsedId {
            self.email = parsedEmail
            self.id = parsedId
        } else {
            return nil
        }
    }
    
}
