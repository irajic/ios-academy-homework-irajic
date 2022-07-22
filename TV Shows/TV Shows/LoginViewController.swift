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
    
    // MARK: - Outlets
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle methodes
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func checkButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func passwordVisibility(_ sender: UIButton) {
        if(sender.isSelected == true) {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            return
        }
        registerUserWith(email: email, password: password)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            return
        }
        loginUserWith(email: email, password: password)
    }
    
    // MARK: - Methodes
    
    private func loginUserWith(email: String, password: String) {
        let loginParameters = [
            "email": email,
            "password": password
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        AF
            .request(
                "https://tv-shows.infinum.academy/users/sign_in",
                method: .post,
                parameters: loginParameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
                switch response.result {
                case .success(let userRoot):
                    self.handleSuccess()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func registerUserWith(email: String, password: String) {
        let registerParameters = [
            "email": email,
            "password": password,
            "password_confirmation": password
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        AF
            .request(
                "https://tv-shows.infinum.academy/users",
                method: .post,
                parameters: registerParameters,
                encoder: JSONParameterEncoder.default
            )
            .validate()
            .responseDecodable(of: UserResponse.self) { response in
                switch response.result {
                case .success(let user):
                    self.handleSuccess()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func handleSuccess() {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
}

struct UserResponse: Decodable {
    let user: User
}

struct User: Decodable {
    let email: String
    let id: String
    let imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case email, id
        case imageUrl = "image_url"
    }
}
