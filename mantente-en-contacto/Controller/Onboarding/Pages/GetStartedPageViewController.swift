//
//  GetStartedPageViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 08/11/25.
//

import UIKit

class GetStartedPageViewController: UIViewController, OnboardingPageContent {

    weak var delegate: OnboardingNavigationDelegate?
    var bottomContentInset: CGFloat = 0 {
        didSet {
            additionalSafeAreaInsets.bottom = bottomContentInset
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "¿Listo para comenzar?"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text =
            "Empieza tu experiencia manteniéndote conectado con quienes te importan."
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("Comenzar", for: .normal)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        style()
        setupUI()
    }

    private func setup() {
        button.addTarget(
            self,
            action: #selector(handleStart),
            for: .touchUpInside
        )
    }

    private func style() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(
            ofSize: 20,
            weight: .semibold
        )
        button.layer.cornerRadius = 12
        button.backgroundColor = .myYellow
        button.contentEdgeInsets = UIEdgeInsets(
            top: 12,
            left: 32,
            bottom: 12,
            right: 32
        )
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .onboardingBg

        let topSpacer = UIView()
        topSpacer.translatesAutoresizingMaskIntoConstraints = false

        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [
            topSpacer, titleLabel, contentLabel, spacer, button,
        ])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 14

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            stack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24
            ),
            stack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24
            ),
            stack.bottomAnchor.constraint(
                lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor
            ),

            topSpacer.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.15
            ),

            spacer.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.1
            ),
        ])
    }

    // MARK: Actions
    @objc func handleStart() {
        delegate?.didTapGetStarted()
    }
}
