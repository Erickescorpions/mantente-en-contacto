//
//  Place.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 23/11/25.
//

import FirebaseFirestore

struct Place: Codable {
    @DocumentID var id: String?
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var createdAt: Timestamp
    
    init(
        name: String,
        address: String,
        latitude: Double,
        longitude: Double,
    ) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = Timestamp(date: Date())
    }
}
