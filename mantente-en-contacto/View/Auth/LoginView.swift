//
//  LoginView.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 08/11/25.
//
import UIKit

final class LoginView: UIView {
        
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
        label.text = "Sign in"
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in into your account"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    let accountField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username or Email"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()
    
    let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign in", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return btn
    }()
    
    let createAccountLink: UIButton = {
        let btn = UIButton(type: .system)
        
        let title = "New user? Create your account"
        let attributed = NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.systemBlue
            ]
        )
        btn.setAttributedTitle(attributed, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    let forgotPasswordLink: UIButton = {
        let btn = UIButton(type: .system)
        
        let title = "Forgot password?"
        let attributed = NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.systemBlue
            ]
        )
        btn.setAttributedTitle(attributed, for: .normal)
        btn.backgroundColor = .clear
        return btn
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            accountField,
            passwordField,
            loginButton,
            createAccountLink,
            forgotPasswordLink
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
