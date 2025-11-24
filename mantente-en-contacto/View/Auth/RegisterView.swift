//
//  RegisterView.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 07/11/25.
//

import UIKit

final class RegisterView: UIView {
    
    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Create your account"
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()
    
    let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()
    
    let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        
        tf.isSecureTextEntry = true
        tf.textContentType = .newPassword
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        
        return tf
    }()

    
    let confirmPasswordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confirm password"
        tf.borderStyle = .roundedRect
        
        tf.isSecureTextEntry = true
        tf.textContentType = .newPassword
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.spellCheckingType = .no
        
        return tf
    }()
    
    let registerButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Register", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.layer.cornerRadius = 8
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            titleLabel,
            usernameField,
            emailField,
            passwordField,
            confirmPasswordField,
            registerButton
        ])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.spacing = 12
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(logo)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            logo.centerXAnchor.constraint(equalTo: centerXAnchor),
            logo.widthAnchor.constraint(equalToConstant: 80),
            logo.heightAnchor.constraint(equalToConstant: 80),
            
            stackView.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
        
        logo.layer.cornerRadius = 40
    }
}
