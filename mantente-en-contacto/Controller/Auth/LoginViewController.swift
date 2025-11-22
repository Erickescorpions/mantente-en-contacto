//
//  LoginViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 08/11/25.
//

import UIKit

class LoginViewController: UIViewController {
    private let contentView = LoginView()
//    private let viewModel = RegisterViewModel()
    

    override func loadView() {
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.loginButton.addTarget(
            self,
            action: #selector(registerTapped),
            for: .touchUpInside
        )
        contentView.createAccountLink.addTarget(
            self,
            action: #selector(goToRegister),
            for: .touchUpInside
        )
    }

    @objc private func registerTapped() {
        let account = contentView.accountField.text ?? ""
        let password = contentView.passwordField.text ?? ""

        print("Tap")
        
//        viewModel.register(
//            username: username,
//            email: email,
//            password: password,
//            confirm: confirm
//        )
    }
    
    @objc private func goToRegister() {
        performSegue(withIdentifier: "Create account", sender: nil)
    }

}
