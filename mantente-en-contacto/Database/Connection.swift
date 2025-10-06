//
//  Conection.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 05/10/25.
//

import CoreData
import Foundation

class Connection: NSObject {

    static let shared = Connection()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MantenteEnContacto")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    private override init() {
        super.init()
        loadFakeData()
    }

    func fetchUser(by id: Int16, in ctx: NSManagedObjectContext) -> User? {
        let rq = NSFetchRequest<User>(entityName: "User")
        rq.fetchLimit = 1
        rq.predicate = NSPredicate(format: "id == %d", id)
        return try? ctx.fetch(rq).first
    }

    func fetchGroup(by id: Int16, in ctx: NSManagedObjectContext) -> Group? {
        let rq = NSFetchRequest<Group>(entityName: "Group")
        rq.fetchLimit = 1
        rq.predicate = NSPredicate(format: "id == %d", id)
        return try? ctx.fetch(rq).first
    }

    func fetchPlace(by id: Int16, in ctx: NSManagedObjectContext) -> Place? {
        let rq = NSFetchRequest<Place>(entityName: "Place")
        rq.fetchLimit = 1
        rq.predicate = NSPredicate(format: "id == %d", id)
        return try? ctx.fetch(rq).first
    }

    private func loadFakeData() {
        if let urlFile = Bundle.main.url(
            forResource: "mock-data",
            withExtension: "json"
        ) {
            let urlLib = FileManager.default.urls(
                for: .libraryDirectory,
                in: .userDomainMask
            ).first!

            let urlDes = urlLib.appendingPathComponent("mock-data.json")

            do {
                // si el archivo ya existe no cargamos la bd
                if !FileManager.default.fileExists(atPath: urlDes.path()) {
                    try FileManager.default.copyItem(at: urlFile, to: urlDes)
                    let data = try Data(contentsOf: urlDes)
                    let dec = JSONDecoder()
                    dec.dateDecodingStrategy = .iso8601
                    let mock = try dec.decode(MockData.self, from: data)

                    let ctx = persistentContainer.viewContext
                    ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

                    ctx.perform {
                        for u in mock.users {
                            let user = User(context: ctx)
                            user.id = u.id
                            user.username = u.username
                            user.phone = u.phone
                            user.avatarPath = u.avatarPath
                        }

                        for g in mock.groups {
                            let group = Group(context: ctx)
                            group.id = g.id
                            group.name = g.name
                            group.createdAt = g.createdAt
                        }

                        for p in mock.places {
                            let place = Place(context: ctx)
                            place.id = p.id
                            place.name = p.name
                            place.address = p.address
                            place.latitude = p.latitude
                            place.longitude = p.longitude
                            place.createdAt = p.createdAt
                        }
                        
                        for m in mock.memberships {
                            guard
                                let u = self.fetchUser(by: m.userId, in: ctx),
                                let g = self.fetchGroup(by: m.groupId, in: ctx)
                            else { continue }

                            let mem = Membership(context: ctx)
                            mem.id = m.id
                            mem.createdAt = m.createdAt
                            mem.user = u
                            mem.group = g
                        }
                        
                        for s in mock.sharedPlaces {
                            guard
                                let u = self.fetchUser(by: s.sharedById, in: ctx),
                                let g = self.fetchGroup(by: s.groupId, in: ctx),
                                let p = self.fetchPlace(by: s.placeId, in: ctx)
                            else { continue }

                            let sp = SharedPlaces(context: ctx)
                            sp.id = s.id
                            sp.createdAt = s.createdAt
                            sp.sharedBy = u
                            sp.group = g
                            sp.place = p
                        }

                        do { try ctx.save() } catch {
                            print("Save error:", error)
                        }
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
