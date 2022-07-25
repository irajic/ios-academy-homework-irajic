//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 7/19/22.
//

import UIKit
import MBProgressHUD
import Alamofire

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    
    // MARK: - Lifecycle methodes
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction private func checkButton(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction private func passwordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    
    @IBAction private func registerButtonTapped(_ sender: UIButton) {
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
    
    @IBAction private func loginButtonTapped(_ sender: UIButton) {
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
    
    func loginUserWith(email: String, password: String) {
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
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success (let userResponse):
                    let headers = dataResponse.response?.headers.dictionary ?? [:]
                    self.handleSuccesfulLogin(for: userResponse.user, headers: headers)
                case .failure:
                    self.handleFaliure()
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
            .responseDecodable(of: UserResponse.self) { [weak self] dataResponse in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                switch dataResponse.result {
                case .success(let user):
                    self.infoLabel.text = "Success: \(user)"
                    self.loginUserWith(email: email, password: password)
                case .failure:
                    self.handleFaliure()
                }
            }
    }
    
    func handleSuccesfulLogin(for user: User, headers: [String: String]) {
        guard let authInfo = try? AuthInfo(headers: headers) else {
            infoLabel.text = "Missing headers"
            return
        }
        infoLabel.text = "\(user)\n\n\(authInfo)"
        let homeStoryboard = UIStoryboard(name: "Home", bundle: .main)
        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        homeViewController.authInfo = authInfo
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    private func handleFaliure() {
        let alertController = UIAlertController(title: nil, message: "Login / registration unseccesful", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
 


