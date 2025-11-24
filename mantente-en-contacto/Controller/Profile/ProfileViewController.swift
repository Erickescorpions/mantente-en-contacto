//
//  ProfileViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 23/08/25.
//

import CoreData
import FirebaseAuth
import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!

    let dataManager = UserRepository()

    override func viewDidLoad() {
        super.viewDidLoad()

        // obtenemos el id del usuario
        guard let userId = Auth.auth().currentUser?.uid else {
            showAlert(message: "You must be logged in to create a place.")
            return
        }

        // hacemos una consulta
        var user: User?
        Task {
            user = await dataManager.loadUserInformation(userId: userId)

            guard let user = user else {
                print("Error loading user data")
                return
            }

            usernameLabel.text = user.username
            emailLabel.text = user.email
            // colocamos la imagen
            if let imageUrl = user.avatarUrl {
                ImageDownloader.shared.downloadImage(from: imageUrl) { image in
                    if image == nil {
                        self.showAlert(
                            message: "Cannot read your profile image"
                        )
                        return
                    }
                    self.profileImage.image = image
                }
            }

        }

        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFill

        profileImage.layer.cornerRadius = profileImage.frame.width / 2

        logoutBtn.backgroundColor = .systemRed
        logoutBtn.setTitleColor(.black, for: .normal)
        logoutBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        logoutBtn.layer.cornerRadius = 12
        logoutBtn.layer.masksToBounds = true

        logoutBtn.contentEdgeInsets = UIEdgeInsets(
            top: 12,
            left: 20,
            bottom: 12,
            right: 20
        )

        logoutBtn.addTarget(
            self,
            action: #selector(logout),
            for: .touchUpInside
        )
    }

    @objc func logout() {
        do {
            try Auth.auth().signOut()
            // vamos al navigationController del login
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let authNC = storyboard.instantiateViewController(
                withIdentifier: "AuthNC"
            )

            // Hacemos que no pueda regresar
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                .first
            {
                window.rootViewController = authNC
                window.makeKeyAndVisible()

                UIView.transition(
                    with: window,
                    duration: 0.25,
                    options: .transitionCrossDissolve,
                    animations: nil
                )
            }
        } catch {
            print("error cerrar la sesion:", error)
            return
        }
    }
}
