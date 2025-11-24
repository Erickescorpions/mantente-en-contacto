//
//  Members.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/11/25.
//

import FirebaseFirestore

struct Members: Codable {
    @DocumentID var id: String?
    var name: String
    var joinedAt: Date
    var userId: String
    var role: String
    
    init(
        name: String,
        userId: String,
        role: String
    ) {
        self.name = name
        self.joinedAt = Date()
        self.userId = userId
        self.role = role
    }
}
