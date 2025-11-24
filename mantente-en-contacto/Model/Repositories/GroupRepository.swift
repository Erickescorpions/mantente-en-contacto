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
                .collectionGroup("memberships")
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
}
