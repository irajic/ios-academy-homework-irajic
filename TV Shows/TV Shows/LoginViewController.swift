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
    
    // MARK: -Properties
    
    
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
        
        let labelView = UIView()
        labelView.addSubview(bigLabel)
        labelView.addSubview(smallLabel)
        
        
        let stackView = UIStackView(arrangedSubviews: [labelView])
        stackView.axis = .vertical
        scrollView.addSubview(stackView)
        
    }
    
}
