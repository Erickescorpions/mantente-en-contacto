//
//  LoginViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 08/11/25.
//

import UIKit

class LoginViewController: UIViewController {
    private let contentView = LoginView()

    override func loadView() {
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.loginButton.addTarget(
            self,
            action: #selector(loginTapped),
            for: .touchUpInside
        )
        contentView.createAccountLink.addTarget(
            self,
            action: #selector(goToRegister),
            for: .touchUpInside
        )
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    private func validate(data: [String: Any]) -> String? {
        for (key, value) in data {

            switch key {

            case "email":
                guard let email = value as? String, !email.isEmpty else {
                    return "Please enter your email."
                }
                guard isValidEmail(email) else {
                    return "Please enter a valid email address."
                }

            case "password":
                guard let password = value as? String, !password.isEmpty else {
                    return "Please enter your password."
                }
                guard password.count >= 6 else {
                    return "Password must be at least 6 characters long."
                }

            default:
                break
            }
        }

        return nil
    }
    
    @objc private func loginTapped() {
        let email = contentView.accountField.text ?? ""
        let password = contentView.passwordField.text ?? ""

        let data: [String: Any] = [
            "email": email,
            "password": password
        ]

        if let errorMessage = validate(data: data) {
            self.showAlert(message: errorMessage)
            return
        }
    }

    
    @objc private func goToRegister() {
        performSegue(withIdentifier: "Create account", sender: nil)
    }

}
