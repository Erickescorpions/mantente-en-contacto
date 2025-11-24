//
//  Members.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/11/25.
//

import FirebaseFirestore

struct Member: Codable {
    @DocumentID var id: String?
    var username: String
    var joinedAt: Date
    var userId: String
    var role: String
    
    init(
        username: String,
        userId: String,
        role: String
    ) {
        self.username = username
        self.joinedAt = Date()
        self.userId = userId
        self.role = role
    }
}
