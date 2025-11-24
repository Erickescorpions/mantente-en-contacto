//
//  UserRepository.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/11/25.
//

import FirebaseFirestore

class UserRepository {
    func loadUserInformation(
        userId: String
    ) async -> User? {
        let db = Firestore.firestore()

        do {
            let userSnapshot =
                try await db
                .collection("users")
                .document(userId)
                .getDocument()

            let user: User = try userSnapshot.data(as: User.self)
            
            return user
        } catch {
            // manejar los errores aqui
            // TODO: throw an error
            print("Error decoding Member", error)
            return nil
        }
    }
}
