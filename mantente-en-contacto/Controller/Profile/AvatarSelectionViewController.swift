//
//  AvatarSelectionViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 22/11/25.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

enum MyCustomError: Error {
    case noUser
    case invalidImage
}

class AvatarSelectionViewController: UIViewController,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select an image to customize your profile"
        label.font = .systemFont(ofSize: 26, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "defaultAvatar")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()

    private lazy var choosePhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Choose a photo", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .myYellow
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.layer.cornerRadius = 10
        btn.contentEdgeInsets = UIEdgeInsets(
            top: 10,
            left: 16,
            bottom: 10,
            right: 16
        )
        btn.addTarget(
            self,
            action: #selector(choosePhotoTapped),
            for: .touchUpInside
        )
        return btn
    }()

    private lazy var finishButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .myYellow
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.layer.cornerRadius = 10
        btn.contentEdgeInsets = UIEdgeInsets(
            top: 12,
            left: 28,
            bottom: 12,
            right: 28
        )
        btn.addTarget(
            self,
            action: #selector(continueTap),
            for: .touchUpInside
        )
        return btn
    }()

    private var selectedImage: UIImage!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }

    // MARK: Layout

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(avatarImageView)
        view.addSubview(choosePhotoButton)
        view.addSubview(finishButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        choosePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 32
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 24
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -24
            ),

            avatarImageView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 28
            ),
            avatarImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            avatarImageView.widthAnchor.constraint(equalToConstant: 160),
            avatarImageView.heightAnchor.constraint(equalToConstant: 160),

            choosePhotoButton.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: 20
            ),
            choosePhotoButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            finishButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -24
            ),
            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishButton.heightAnchor.constraint(equalToConstant: 50),
        ])

        avatarImageView.layer.cornerRadius = 80
    }

    // MARK: Actions

    @objc private func choosePhotoTapped() {
        let actionSheet = UIAlertController(
            title: "Choose a photo",
            message: "Select an option",
            preferredStyle: .actionSheet
        )

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(
                UIAlertAction(title: "Take a photo", style: .default) { _ in
                    self.openImagePicker(source: .camera)
                }
            )
        }

        actionSheet.addAction(
            UIAlertAction(title: "Choose from library", style: .default) { _ in
                self.openImagePicker(source: .photoLibrary)
            }
        )

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(actionSheet, animated: true)
    }

    private func openImagePicker(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        picker.allowsEditing = false
        present(picker, animated: true)
    }

    // MARK: UIImagePickerController
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:
            Any]
    ) {
        if let selectedImage = info[.originalImage] as? UIImage {
            avatarImageView.image = selectedImage
            self.selectedImage = selectedImage
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    @objc private func continueTap() {
        Task {
            await uploadImage()
        }
    }

    private func uploadImage() async {
        do {
            guard let userId = Auth.auth().currentUser?.uid else {
                throw MyCustomError.noUser
            }
            
            guard let imageData = selectedImage.jpegData(compressionQuality: 0.8) else {
                throw MyCustomError.invalidImage
            }
            
            let storageRef = Storage.storage().reference()
            let avatarRef = storageRef.child("images/\(userId)")
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            _ = try await avatarRef.putDataAsync(imageData, metadata: metadata)
            let url = try await avatarRef.downloadURL()
            let db = Firestore.firestore()
            try await db.collection("users").document(userId).updateData([
                "avatarUrl": url.absoluteString
            ])
            
            continueToApp()
            
        } catch {
            print("Error saving image", error)
            showAlert(message: "There was a problem saving your image. Please try again.")
        }
    }
    
    func continueToApp() {
        performSegue(withIdentifier: "ruGoToApp", sender: nil)
    }
}
