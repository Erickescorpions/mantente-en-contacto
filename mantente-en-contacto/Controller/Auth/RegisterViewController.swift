//
//  RegisterViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 07/11/25.
//

import UIKit

class RegisterViewController: UIViewController {

    private let contentView = RegisterView()
//    private let viewModel = RegisterViewModel()

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

    @objc private func registerTapped() {
        let username = contentView.usernameField.text ?? ""
        let email = contentView.emailField.text ?? ""
        let password = contentView.passwordField.text ?? ""
        let confirm = contentView.confirmPasswordField.text ?? ""

        print("Tap")
        
//        viewModel.register(
//            username: username,
//            email: email,
//            password: password,
//            confirm: confirm
//        )
    }
}
