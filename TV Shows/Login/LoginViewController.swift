//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Infinum on 7/15/22.
//

import UIKit
import MBProgressHUD

final class LoginViewController: UIViewController {
    
    private var numberOfTaps:Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.viewOutlet.backgroundColor = UIColor.gray
        
        self.button.backgroundColor = .clear
        self.button.layer.cornerRadius = 5
        self.button.layer.borderWidth = 1
        self.button.layer.borderColor = UIColor.black.cgColor
        
        self.labelOutlet.textColor = UIColor.darkGray
        self.labelOutlet.font = UIFont(name: "HelveticaNeue", size: 30)
        
        self.activityOutlet.style = .large
        
        startActivity()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: stopActivity)
        
    }
    
    
    @IBAction private func buttonAction(_ sender: Any) {
        
        numberOfTaps+=1
        self.labelOutlet.text="\(numberOfTaps)"
        
    }
    
    private func startActivity() {
        
        activityOutlet.startAnimating()
    
    }
    
    private func stopActivity() {
        
        activityOutlet.stopAnimating()
    
    }

    @IBAction private func startCounter(_ sender: Any) {
        
        startActivity()
        
    }
    
    @IBAction private func stopCounter(_ sender: Any) {
        
        stopActivity()
        
    }
    
    @IBOutlet weak var labelOutlet: UILabel!
    @IBOutlet var viewOutlet: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var activityOutlet: UIActivityIndicatorView!
    
}
