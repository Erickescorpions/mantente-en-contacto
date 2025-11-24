//
//  ProfileViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 23/08/25.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    let profileMenuOptions: [(title: String, icon: UIImage)] = [
        (title: "Personal Information", icon: UIImage(systemName: "person.circle")!),
        (title: "Payment", icon: UIImage(systemName: "creditcard")!),
        (title: "Logout", icon: UIImage(systemName: "xmark")!)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // obtenemos el id del usuario
        let userId = UserDefaults.standard.integer(forKey: "userId")
//        let ctx = Connection.shared.persistentContainer.viewContext

//        let fetch: NSFetchRequest<User> = User.fetchRequest()
//        fetch.fetchLimit = 1
//        fetch.predicate = NSPredicate(format: "id == %d", userId)
//
//        do {
//            if let user = try ctx.fetch(fetch).first {
//                usernameLabel.text = user.username
//            } else {
//                print("No se encontró usuario con id \(userId)")
//            }
//        } catch {
//            print("Error al buscar usuario:", error)
//        }
        
        profileImage.layer.masksToBounds = true
        profileImage.contentMode = .scaleAspectFit
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.borderWidth = 2
        profileImage.backgroundColor = UIColor.systemYellow
        
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        as! ProfileTableViewCell
        
        let option = profileMenuOptions[indexPath.row]
        cell.iconImage.image = option.icon
        cell.title.text = option.title
        
        return cell
    }
    
    
}
