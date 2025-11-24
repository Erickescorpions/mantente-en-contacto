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

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        layout()
        
        floatingActionButton.addTarget(self, action: #selector(goToAddNewGroup), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func loadData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            showAlert(message: "You must be logged in to show your groups.")
            return
        }

        Task {
            groups = await dataManager.loadGroupsWhereCurrentUserIsMember(
                userId: userId
            )
            for group in groups {
                guard let groupId = group.id else { return }
                let membersPerGroup =
                    await memberDataManager.loadMembersPerGroup(
                        groupId: groupId
                    )
                members.append(membersPerGroup)
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
        let members = members[section]
        return members.count
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
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath
            ) as! GroupTableViewCell

        let group = groups[indexPath.section]
        let members = members[indexPath.section]
        let member = members[indexPath.row]

        //        if let path = member.avatarPath, !path.isEmpty,
        //            let img = UIImage(named: path)
        //        {
        //            cell.memberImage.image = img
        //        } else {
        //            cell.memberImage.image = UIImage(systemName: "person.crop.circle")
        //        }

        cell.memberImage.image = UIImage(systemName: "person.crop.circle")
        cell.memberUsername.text = member.username

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    )
        -> UISwipeActionsConfiguration?
    {

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Remove"
        ) { _, _, success in
            let group = self.groups[indexPath.section]
            let members = self.members[indexPath.section]

            guard indexPath.row < members.count else {
                success(false)
                return
            }

            let member = members[indexPath.row]
            let username = member.username ?? "this member"

            let alert = UIAlertController(
                title: "Remove Member",
                message:
                    "Remove \(username) from \(group.name ?? "this group")?",
                preferredStyle: .alert
            )

            let confirm = UIAlertAction(title: "Confirm", style: .destructive) {
                _ in
                // lo eliminamos del array
                // TODO: Falta eliminarlo de firestore
                self.members.remove(at: indexPath.row)
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
