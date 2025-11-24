//
//  AddPlaceViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 23/11/25.
//
import UIKit
import MapKit
import FirebaseFirestore

final class AddPlaceViewController: UIViewController {
    
    var coordinates: CLLocationCoordinate2D!
    var placeName: String = ""
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a new place"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let placeNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Place name"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .words
        tf.autocorrectionType = .no
        return tf
    }()
    
    private let addressField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Address"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .words
        tf.autocorrectionType = .no
        return tf
    }()
    
    private let sharedWithGroupsLabel: UILabel = {
        let label = UILabel()
        label.text = "Shared with"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let noGroupsCreatedLabel: UILabel = {
        let label = UILabel()
        label.text = "You don't have any groups yet"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add", for: .normal)
        btn.backgroundColor = .myYellow
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.layer.cornerRadius = 12
        btn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        btn.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private let groupsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.allowsMultipleSelection = true
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    private var myGroups: [String] = [
        "Family",
        "Close friends",
        "Work",
        "Gym buddies"
    ]
    
    private var selectedGroups = Set<Int>()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Add place"
        
        setupTableView()
        setupLayout()
        updateGroupsVisibility()
        print(self.placeName)
        if self.placeName != "" {
            placeNameField.text = self.placeName
        }
    }
    
    // MARK: Setup
    
    private func setupTableView() {
        groupsTableView.dataSource = self
        groupsTableView.delegate = self
        groupsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "GroupCell")
    }
    
    private func setupLayout() {
        // Usamos un stack para los campos de texto
        let fieldsStack = UIStackView(arrangedSubviews: [
            titleLabel,
            placeNameField,
            addressField,
            sharedWithGroupsLabel
        ])
        fieldsStack.axis = .vertical
        fieldsStack.spacing = 20
        fieldsStack.alignment = .fill
        fieldsStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(fieldsStack)
        view.addSubview(groupsTableView)
        view.addSubview(noGroupsCreatedLabel)
        view.addSubview(saveButton)
        
        fieldsStack.translatesAutoresizingMaskIntoConstraints = false
        groupsTableView.translatesAutoresizingMaskIntoConstraints = false
        noGroupsCreatedLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Campos arriba
            fieldsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            fieldsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            fieldsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            // Tabla de grupos debajo del label "Shared with"
            groupsTableView.topAnchor.constraint(equalTo: fieldsStack.bottomAnchor, constant: 20),
            groupsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            groupsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            groupsTableView.heightAnchor.constraint(equalToConstant: 250),
            
            // Label cuando no hay grupos
            noGroupsCreatedLabel.topAnchor.constraint(equalTo: fieldsStack.bottomAnchor, constant: 40),
            noGroupsCreatedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            noGroupsCreatedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            // Botón abajo
            saveButton.topAnchor.constraint(greaterThanOrEqualTo: groupsTableView.bottomAnchor, constant: 16),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
    
    private func updateGroupsVisibility() {
        let hasGroups = !myGroups.isEmpty
        groupsTableView.isHidden = !hasGroups
        noGroupsCreatedLabel.isHidden = hasGroups
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonTapped() {
        let placeName = placeNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let address = addressField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let selectedGroupNames = selectedGroups.map { myGroups[$0] }

        // Validacion de datos
        guard !placeName.isEmpty else {
            showAlert(message: "Please enter a place name")
            return
        }

        guard !address.isEmpty else {
            showAlert(message: "Please enter an address")
            return
        }

        guard let coordinates = coordinates else {
            showAlert(message: "Please select a place on the map first")
            return
        }

        let place = Place(
            name: placeName,
            address: address,
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )

        // TODO: hace falta la logica para guardar los grupos
        let db = Firestore.firestore()

        do {
            try db.collection("places").addDocument(from: place)
            // Si todo salió bien, cerramos
            dismiss(animated: true)
        } catch {
            showAlert(title: "Error", message: "An error ocurred while saving the place.")
        }
    }

}

// MARK: UITableView

extension AddPlaceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        let groupName = myGroups[indexPath.row]
        cell.textLabel?.text = groupName
        
        if selectedGroups.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleGroupSelection(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        toggleGroupSelection(at: indexPath)
    }
    
    private func toggleGroupSelection(at indexPath: IndexPath) {
        if selectedGroups.contains(indexPath.row) {
            selectedGroups.remove(indexPath.row)
        } else {
            selectedGroups.insert(indexPath.row)
        }
        
        if let cell = groupsTableView.cellForRow(at: indexPath) {
            cell.accessoryType = selectedGroups.contains(indexPath.row) ? .checkmark : .none
        }
    }
}
