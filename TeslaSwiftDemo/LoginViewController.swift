//
//  LoginViewController.swift
//  TeslaSwift
//
//  Created by Joao Nunes on 05/03/16.
//  Copyright © 2016 Joao Nunes. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let loginDone = Notification.Name("loginDone")
}

class LoginViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!

    @IBAction func webLoginAction(_ sender: AnyObject) {
        let (webloginViewController, result) = api.authenticateWeb()

        guard let safeWebloginViewController = webloginViewController else { return }

        self.present(safeWebloginViewController, animated: true, completion: nil)

        Task { @MainActor in
            do {
                _ = try await result()
                self.messageLabel.text = "Authentication success"
                NotificationCenter.default.post(name: Notification.Name.loginDone, object: nil)

                self.dismiss(animated: true, completion: nil)
            } catch let error {
                self.messageLabel.text = "Authentication failed: \(error)"
            }

        }
    }
}
