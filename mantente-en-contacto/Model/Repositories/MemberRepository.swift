//
//  MemberRepository.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/11/25.
//
import FirebaseFirestore

class MemberRepository {
    
    func loadMembersPerGroup(groupId: String) async -> [Member] {
        let db = Firestore.firestore()
        
        do {
            let snapshot = try await db
                .collection("groups")
                .document(groupId)
                .collection("memberships")
                .getDocuments()
            
            let members: [Member] = try snapshot.documents.map { doc in
                try doc.data(as: Member.self)
            }
            
            return members
            
        } catch {
            print("Error loading members for group \(groupId):", error)
            return []
        }
    }
}

