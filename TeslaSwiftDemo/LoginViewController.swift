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
	@IBAction func loginAction(sender: AnyObject) {
		
		if let email = emailTextField.text,
			let password = passwordTextField.text {
				
				TeslaSwift.defaultInstance.authenticate(email, password: password).andThen { (result) -> Void in
					
					switch result {
					case .Success(_):
						self.dismissViewControllerAnimated(true, completion: nil)
					case .Failure(let error):
						self.messageLabel.text = "Error: \(error as NSError)"
					}
					
				}
		} else {
			messageLabel.text = "Please add your credentials"
		}
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	
}
