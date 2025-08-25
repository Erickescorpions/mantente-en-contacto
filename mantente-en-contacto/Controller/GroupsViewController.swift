//
//  GroupsViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/08/25.
//

import UIKit

class GroupsViewController: UIViewController {
    
    let data: [Group] = GroupDataManager().all()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].members.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].groupName
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupTableViewCell
        
        let member = data[indexPath.section].members[indexPath.row]
        cell.memberImage.image = UIImage(named: member.perfilPicture!)
        cell.memberUsername.text = member.username
        
        return cell
    }
}
