//
//  LoginViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 05/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	
	
	@IBOutlet weak var messageLabel: UILabel!
	
	@IBAction func loginAction(_ sender: AnyObject) {
		
		if let email = emailTextField.text,
			let password = passwordTextField.text {
			
			UserDefaults.standard.set(email, forKey: "tesla.email")
			UserDefaults.standard.set(password, forKey: "tesla.password")
			UserDefaults.standard.synchronize()
			
			api.authenticate(email: email, password: password).then {
				(token) -> Void in
				
				self.dismiss(animated: true, completion: nil)
				
				}.catch { (error) in
					if case TeslaError.authenticationFailed =  error {
						self.messageLabel.text = "Authentication failed"
					} else {
						self.messageLabel.text = "Error: \(error as NSError)"
					}
				}
		} else {
			messageLabel.text = "Please add your credentials"
		}
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		
		if let email = UserDefaults.standard.object(forKey: "tesla.email") as? String {
			emailTextField.text = email
		}
		if let password = UserDefaults.standard.object(forKey: "tesla.password") as? String {
			passwordTextField.text = password
		}
		
    }

	
}
