//
//  Group.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 24/11/25.
//

import FirebaseFirestore

struct Group: Codable {
    @DocumentID var id: String?
    var name: String
    var color: String
    var createdAt: Date
    var ownerId: String
    
    init(
        name: String,
        color: String,
        ownerId: String
    ) {
        self.name = name
        self.color = color
        self.createdAt = Date()
        self.ownerId = ownerId
    }
}
