//
//  AddGroupViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/11/25.
//

import UIKit
import FirebaseAuth

final class AddGroupViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a new group"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        return label
    }()

    private let groupNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Group name"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .words
        tf.autocorrectionType = .no
        return tf
    }()

    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Group color"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let colorPreviewView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.separator.cgColor
        view.backgroundColor = .systemYellow  // color por defecto
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var pickColorButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Choose color", for: .normal)
        btn.setTitleColor(.label, for: .normal)
        btn.backgroundColor = .myLightYellow
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.layer.cornerRadius = 10
        btn.contentEdgeInsets = UIEdgeInsets(
            top: 8,
            left: 16,
            bottom: 8,
            right: 16
        )
        btn.addTarget(
            self,
            action: #selector(pickColorTapped),
            for: .touchUpInside
        )
        return btn
    }()

    private let membersLabel: UILabel = {
        let label = UILabel()
        label.text = "Members"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()

    private let membersHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Search members by email or username"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()

    private let memberSearchField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search by email or username"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()

    private lazy var addMemberButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add", for: .normal)
        btn.backgroundColor = .myYellow
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.layer.cornerRadius = 10
        btn.contentEdgeInsets = UIEdgeInsets(
            top: 8,
            left: 16,
            bottom: 8,
            right: 16
        )
        btn.addTarget(
            self,
            action: #selector(addMemberTapped),
            for: .touchUpInside
        )
        return btn
    }()

    private let membersTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = true
        tableView.tableFooterView = UIView()
        return tableView
    }()

    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Save group", for: .normal)
        btn.backgroundColor = .myYellow
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.layer.cornerRadius = 12
        btn.contentEdgeInsets = UIEdgeInsets(
            top: 12,
            left: 24,
            bottom: 12,
            right: 24
        )
        btn.addTarget(
            self,
            action: #selector(saveButtonTapped),
            for: .touchUpInside
        )
        return btn
    }()

    
    private var selectedMembers: [String] = []
    private var selectedColor: UIColor = .systemYellow

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add group"
        view.backgroundColor = .systemBackground

        setupTableView()
        setupLayout()
    }

    // MARK: Setup

    private func setupTableView() {
        membersTableView.dataSource = self
        membersTableView.delegate = self
        membersTableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "MemberCell"
        )
    }

    private func setupLayout() {
        let colorRowStack = UIStackView(arrangedSubviews: [
            colorPreviewView,
            pickColorButton,
        ])
        colorRowStack.axis = .horizontal
        colorRowStack.spacing = 12
        colorRowStack.alignment = .center

        NSLayoutConstraint.activate([
            colorPreviewView.widthAnchor.constraint(equalToConstant: 40),
            colorPreviewView.heightAnchor.constraint(equalToConstant: 24),
        ])

        let topStack = UIStackView(arrangedSubviews: [
            titleLabel,
            groupNameField,
            colorLabel,
            colorRowStack,
            membersLabel,
            membersHintLabel,
        ])
        topStack.axis = .vertical
        topStack.spacing = 12
        topStack.alignment = .fill

        let memberSearchStack = UIStackView(arrangedSubviews: [
            memberSearchField,
            addMemberButton,
        ])
        memberSearchStack.axis = .horizontal
        memberSearchStack.spacing = 8
        memberSearchStack.alignment = .fill
        memberSearchStack.distribution = .fillProportionally

        view.addSubview(topStack)
        view.addSubview(memberSearchStack)
        view.addSubview(membersTableView)
        view.addSubview(saveButton)

        topStack.translatesAutoresizingMaskIntoConstraints = false
        memberSearchStack.translatesAutoresizingMaskIntoConstraints = false
        membersTableView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 30
            ),
            topStack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 25
            ),
            topStack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -25
            ),

            // Buscador
            memberSearchStack.topAnchor.constraint(
                equalTo: topStack.bottomAnchor,
                constant: 12
            ),
            memberSearchStack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 25
            ),
            memberSearchStack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -25
            ),
            addMemberButton.widthAnchor.constraint(equalToConstant: 90),

            // Tabla de miembros
            membersTableView.topAnchor.constraint(
                equalTo: memberSearchStack.bottomAnchor,
                constant: 12
            ),
            membersTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 25
            ),
            membersTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -25
            ),
            membersTableView.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 200
            ),

            saveButton.topAnchor.constraint(
                greaterThanOrEqualTo: membersTableView.bottomAnchor,
                constant: 16
            ),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -30
            ),
        ])
    }

    // MARK: - Actions

    @objc private func addMemberTapped() {
        // validamos que este ingresando texto
        let memberUsername =
            memberSearchField.text?.trimmingCharacters(
                in: .whitespacesAndNewlines
            ) ?? ""
        guard !memberUsername.isEmpty else {
            showAlert(message: "Please enter a username to add a member.")
            return
        }

        // TODO: Buscar usuario en Firebase
        
        if !selectedMembers.contains(memberUsername) {
            selectedMembers.append(memberUsername)
            membersTableView.reloadData()
        } else {
            showAlert(message: "This user is already part of the group.")
            return
        }

        memberSearchField.text = ""
    }

    @objc private func pickColorTapped() {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        picker.selectedColor = selectedColor  // color actual por defecto
        present(picker, animated: true)
    }

    @objc private func saveButtonTapped() {
        let name =
            groupNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            ?? ""

        // validacion
        guard !name.isEmpty else {
            showAlert(message: "Please enter a group name.")
            return
        }

        guard !selectedMembers.isEmpty else {
            showAlert(message: "Please add at least one member.")
            return
        }
        
        guard let userId = Auth.auth().currentUser?.uid else {
            showAlert(message: "You must be logged in to create a place.")
            return
        }

        let colorHex = selectedColor.toHexString()

        let group = Group(
            name: name,
            color: colorHex,
            ownerId: userId
        )

        // TODO: Guardarlo en Firebase
        
        dismiss(animated: true)
    }
}

// MARK: UITableView
extension AddGroupViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return selectedMembers.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MemberCell",
            for: indexPath
        )
        let member = selectedMembers[indexPath.row]
        cell.textLabel?.text = member
        return cell
    }

    // Permitir eliminar miembros tipo swipe to delete
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            selectedMembers.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: UIColorPicker
extension AddGroupViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(
        _ viewController: UIColorPickerViewController
    ) {
        selectedColor = viewController.selectedColor
        colorPreviewView.backgroundColor = selectedColor
    }

    func colorPickerViewControllerDidFinish(
        _ viewController: UIColorPickerViewController
    ) {
        selectedColor = viewController.selectedColor
        colorPreviewView.backgroundColor = selectedColor
    }
}
