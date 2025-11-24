//
//  User.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/11/25.
//

import FirebaseFirestore

struct User: Codable {
    @DocumentID var id: String?
    var username: String
    var avatarUrl: String?
    var email: String
    var createdAt: Date
    
    init(
        username: String,
        avatarUrl: String? = nil,
        email: String,
    ) {
        self.username = username
        self.email = email
        self.avatarUrl = avatarUrl
        self.createdAt = Date()
    }
}
