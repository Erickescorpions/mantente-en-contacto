//
//  GroupRepository.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/11/25.
//

import FirebaseFirestore

class GroupRepository {
    func loadGroupsWhereCurrentUserIsMember(
        userId: String
    ) async -> [Group] {
        var result: [Group] = []
        let db = Firestore.firestore()

        do {
            let membersSnapshot =
                try await db
                .collectionGroup("members")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()

            for memberDoc in membersSnapshot.documents {
                guard let groupRef = memberDoc.reference.parent.parent else {
                    continue
                }
                let groupSnapshot = try await groupRef.getDocument()
                if groupSnapshot.exists {
                    do {
                        let group = try groupSnapshot.data(as: Group.self)
                        result.append(group)
                    } catch {
                        print("Error decoding Group: \(error)")
                    }
                }
            }
            
            return result
        } catch {
            // manejar los errores aqui
            // TODO: throw an error
            print("Error decoding Member", error)
            return []
        }
    }
    
    func createGroup(group: Group, members: [User]) async -> Bool {
            let db = Firestore.firestore()
            let batch = db.batch()
            let groupRef = db.collection("groups").document()
            
            do {
                try batch.setData(from: group, forDocument: groupRef)
                for user in members {
                    let member = Member(username: user.username, userId: user.id!, role: "member")
                    let memberRef = groupRef.collection("members").document()
                    try batch.setData(from: member, forDocument: memberRef)
                }
                try await batch.commit()
                return true
                
            } catch {
                print("An error occurred while creating the group and members:", error)
                return false
            }
        }
}
