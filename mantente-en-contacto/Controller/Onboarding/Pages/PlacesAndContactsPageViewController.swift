//
//  PlacesAndContactsPageViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 08/11/25.
//

import UIKit

class PlacesAndContactsPageViewController: UIViewController, OnboardingPageContent {

    var bottomContentInset: CGFloat = 0 {
        didSet {
            additionalSafeAreaInsets.bottom = bottomContentInset
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Mantente en contacto"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = """
            Para mantenerte en contacto con quienes elijas, podrás registrar los lugares que visitas con frecuencia.

            Tú decides quién recibe la notificación.
            """
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "onboardingPlaces")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .onboardingBg

        let topSpacer = UIView()
        topSpacer.translatesAutoresizingMaskIntoConstraints = false

        let textStack = UIStackView(arrangedSubviews: [
            titleLabel, contentLabel,
        ])
        textStack.axis = .vertical
        textStack.alignment = .center
        textStack.spacing = 14

        let contentStack = UIStackView(arrangedSubviews: [imageView, textStack])
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 24
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let mainStack = UIStackView(arrangedSubviews: [topSpacer, contentStack])
        mainStack.axis = .vertical
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            mainStack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24
            ),
            mainStack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24
            ),
            mainStack.bottomAnchor.constraint(
                lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor
            ),

            topSpacer.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 0.15
            ),

            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.6)
        ])
    }

}
