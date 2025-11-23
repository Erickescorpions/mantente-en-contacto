//
//  RegisterViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 07/11/25.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    private let contentView = RegisterView()

    override func loadView() {
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.registerButton.addTarget(
            self,
            action: #selector(registerTapped),
            for: .touchUpInside
        )
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    private func validate(data: [String: String]) -> String? {
        for (key, value) in data {

            switch key {

            case "email":
                guard !value.isEmpty else {
                    return "Please enter your email."
                }
                guard isValidEmail(value) else {
                    return "Please enter a valid email address."
                }

            case "password":
                guard !value.isEmpty else {
                    return "Please enter your password."
                }
                guard value.count >= 6 else {
                    return "Password must be at least 6 characters long."
                }
                
            case "username":
                guard !value.isEmpty else {
                    return "Please enter your username."
                }

            case "confirmationPassword":
                guard !value.isEmpty else {
                    return "Please confirm your password."
                }

            default:
                break
            }
        }
        
        if data["confirmationPassword"] != data["password"] {
            return "Passwords must match"
        }
            
        return nil
    }


    @objc private func registerTapped() {
        let username = contentView.usernameField.text ?? ""
        let email = contentView.emailField.text ?? ""
        let password = contentView.passwordField.text ?? ""
        let confirmationPassword = contentView.confirmPasswordField.text ?? ""

        let data = [
            "username": username,
            "email": email,
            "password": password,
            "confirmationPassword": confirmationPassword
        ]
        
        if let errorMessage = validate(data: data) {
            self.showAlert(message: errorMessage)
            return
        }
        
        // creamos la cuenta en firebase
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            // Si hay error, lo manejamos
            if let error = error as NSError? {
                if let errorCode = AuthErrorCode(rawValue: error.code) {
                    
                    switch errorCode {
                    case .invalidEmail:
                        self.showAlert(message: "The email address is badly formatted.")
                        
                    case .emailAlreadyInUse:
                        self.showAlert(message: "This email is already registered.")
                        
                    case .weakPassword:
                        self.showAlert(message: "Password must be at least 6 characters.")
                        
                    default:
                        self.showAlert(message: error.localizedDescription)
                    }
                }
                return
            }
            
            guard let user = authResult?.user else {
                self.showAlert(message: "Unexpected error creating your account.")
                return
            }
            
            self.continueToAvatarSelection()
        }

        
    }
    
    private func continueToAvatarSelection() {
        performSegue(withIdentifier: "AvatarSelection", sender: nil)
    }

}
