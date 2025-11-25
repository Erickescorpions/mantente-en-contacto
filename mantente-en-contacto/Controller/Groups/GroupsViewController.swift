//
//  GroupsViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/08/25.
//

import FirebaseAuth
import UIKit

class GroupsViewController: UIViewController {

    private let dataManager = GroupRepository()
    private let memberDataManager = MemberRepository()
    private var groups: [Group] = []
    private var members: [[Member]] = []

    private let floatingActionButton = FloatingActionButton()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Groups"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        layout()
        loadData()
        
        floatingActionButton.addTarget(
            self,
            action: #selector(goToAddNewGroup),
            for: .touchUpInside
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()   // refresca al volver del modal
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 50
        
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            showAlert(message: "You must be logged in to show your groups.")
            return
        }

        Task { [weak self] in
            guard let self = self else { return }
            
            self.groups.removeAll()
            self.members.removeAll()

            let loadedGroups = await self.dataManager.loadGroupsWhereCurrentUserIsMember(
                userId: userId
            )
            
            var membersByGroup: [[Member]] = []
            
            for group in loadedGroups {
                guard let groupId = group.id else { continue }
                let membersPerGroup = await self.memberDataManager.loadMembersPerGroup(
                    groupId: groupId
                )
                membersByGroup.append(membersPerGroup)
            }
            
            self.groups = loadedGroups
            self.members = membersByGroup
            print(self.members)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func layout() {
        view.addSubview(floatingActionButton)
        floatingActionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            floatingActionButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -24
            ),
            floatingActionButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -24
            ),
        ])
    }
    
    // MARK: Acciones
    @objc func goToAddNewGroup() {
        performSegue(withIdentifier: "toAddNewGroup", sender: nil)
    }
}

extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        let groupMembers = members[section]
        return groupMembers.count
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 50
    }

    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return groups[section].name
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as? GroupTableViewCell else {
            return UITableViewCell()
        }

        let groupMembers = members[indexPath.section]
        let member = groupMembers[indexPath.row]

        cell.memberImage.image = UIImage(systemName: "person.crop.circle")
        cell.memberUsername.text = member.username

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Remove"
        ) { _, _, success in
            let group = self.groups[indexPath.section]
            let groupMembers = self.members[indexPath.section]

            guard indexPath.row < groupMembers.count else {
                success(false)
                return
            }

            let member = groupMembers[indexPath.row]
            let username = member.username ?? "this member"

            let alert = UIAlertController(
                title: "Remove Member",
                message:
                    "Remove \(username) from \(group.name ?? "this group")?",
                preferredStyle: .alert
            )

            let confirm = UIAlertAction(title: "Confirm", style: .destructive) {
                _ in
                // TODO: eliminar de Firestore

                self.members[indexPath.section].remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                success(true)
            }
            alert.addAction(confirm)

            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                success(false)
            }
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
