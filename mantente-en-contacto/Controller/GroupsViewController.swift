//
//  GroupsViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/08/25.
//

import UIKit

class GroupsViewController: UIViewController {

    private let floatingActionButton = FloatingActionButton()
    let data: [Group] = GroupDataManager().all()

    override func viewDidLoad() {
        super.viewDidLoad()

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
}

extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        let group = data[section]
        let members = group.members as? Set<Membership> ?? []
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
        return data[section].name
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "cell",
                for: indexPath
            ) as! GroupTableViewCell

        let group = data[indexPath.section]

        let members: [User] = (group.members as? Set<Membership> ?? [])
            .compactMap { $0.user }
            .sorted { ($0.username ?? "") < ($1.username ?? "") }

        let member = members[indexPath.row]

        if let path = member.avatarPath, !path.isEmpty,
            let img = UIImage(named: path)
        {
            cell.memberImage.image = img
        } else {
            cell.memberImage.image = UIImage(systemName: "person.crop.circle")
        }

        cell.memberUsername.text = member.username

        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
                   -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Remove") { _, _, success in
            let group = self.data[indexPath.section]
  
            let members = (group.members as? Set<Membership> ?? [])
                .sorted { ($0.user?.username ?? "") < ($1.user?.username ?? "") }
            
            guard indexPath.row < members.count else {
                success(false)
                return
            }
            
            let membership = members[indexPath.row]
            let username = membership.user?.username ?? "this member"

            let alert = UIAlertController(
                title: "Remove Member",
                message: "Remove \(username) from \(group.name ?? "this group")?",
                preferredStyle: .alert
            )
            
            let confirm = UIAlertAction(title: "Confirm", style: .destructive) { _ in
                let ctx = Connection.shared.persistentContainer.viewContext
                ctx.delete(membership)
                
                do {
                    try ctx.save()
                    tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                } catch {
                    print("Error deleting membership:", error)
                }
                
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
