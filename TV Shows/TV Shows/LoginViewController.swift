//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 7/19/22.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: -Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var checkboxButton: UIButton!
    
    
    // MARK: -Lifecycle methodes
    override func viewDidLoad() {
        super.viewDidLoad()
        createStackView()
    }
    
    // MARK: -Methodes
    
    private func createStackView() {
        
        let bigLabel = UILabel(frame: CGRect(x: 20,y: 188, width: 120, height: 41))
        bigLabel.text = "Login"
        bigLabel.textColor = .white
        bigLabel.font = UIFont.boldSystemFont(ofSize: 40)
        
        let smallLabel = UILabel(frame: CGRect(x: 20, y: 249, width: 350, height: 20))
        smallLabel.text = "In oreder to continue please login"
        smallLabel.textColor = .white
        smallLabel.adjustsFontSizeToFitWidth = true
        
        let rememberMeLabel = UILabel(frame: CGRect(x: 52, y: 424, width: 300, height: 30))
        rememberMeLabel.text = "Remember me"
        rememberMeLabel.textColor = .white
        rememberMeLabel.adjustsFontSizeToFitWidth = true
        
        let loginButton = UIButton(frame: CGRect(x: 39, y: 485, width: 312, height: 45))
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 15
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.clear.cgColor
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(UIColor.blue, for: .normal)
        
        
        let registerButton = UIButton(frame: CGRect(x: 138, y: 551, width: 109, height: 20))
        registerButton.backgroundColor = UIColor.clear
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.setTitle("Register", for: .normal)
        
        let labelView = UIView()
        labelView.addSubview(bigLabel)
        labelView.addSubview(smallLabel)
        labelView.addSubview(rememberMeLabel)
        
        let buttonView = UIView()
        buttonView.addSubview(loginButton)
        buttonView.addSubview(registerButton)
        
        
        let stackView = UIStackView(arrangedSubviews: [labelView, buttonView])
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        
    }
    
    // MARK: -Actions
    @IBAction func buttonClicked(_ sender: UIButton) {
        if(sender.isSelected == true) {
            sender.setBackgroundImage(UIImage(named: "checkmark.rectangle"), for: UIControl.State.selected)
            sender.isSelected = false
        }
        else {
            sender.setBackgroundImage(UIImage(named: "rectangle"), for: UIControl.State.normal)
            sender.isSelected = true
        }
    }
    
}
