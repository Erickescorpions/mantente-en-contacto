//
//  GroupDataManager.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/08/25.
//

class GroupDataManager {
    
    private let home = Place(name: "home", address: "Fake Street 123", photo: nil)
    private let work = Place(name: "work", address: "Fake Street 321", photo: nil)
    
    private lazy var groups: [Group] = [
        Group(placesShared: [home, work], groupName: "Family", members: [
            User(name: "Nancy S", username: "Nan", perfilPicture: "user2"),
            User(name: "Renada V", username: "Ren", perfilPicture: "user3"),
            User(name: "Nelly S", username: "Nelulis", perfilPicture: "user2"),
            User(name: "Carolina P", username: "Caro", perfilPicture: "user3")
        ]),
        Group(placesShared: [work], groupName: "My Team Job", members: [
            User(name: "Ricardo", username: "Richie", perfilPicture: "user4"),
            User(name: "Fernanda", username: "Fer", perfilPicture: "user3"),
            User(name: "Isaias", username: "Isa", perfilPicture: "user1")
        ])
    ]
    
    func getGroup(at index : Int) -> Group {
        return groups[index]
    }
    
    func count() -> Int {
        return groups.count
    }
    
    func all() -> [Group] {
        return groups
    }
}
