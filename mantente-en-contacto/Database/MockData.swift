//
//  MockData.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 05/10/25.
//

import Foundation

struct MockData: Codable {
    let users: [UserDTO]
    let groups: [GroupDTO]
    let places: [PlaceDTO]
    let memberships: [MembershipDTO]
    let sharedPlaces: [SharedPlaceDTO]
    let defaults: DefaultsDTO?
}

struct UserDTO: Codable { let id: Int16, username: String, phone: String?, avatarPath: String? }
struct GroupDTO: Codable { let id: Int16, name: String, createdAt: Date }
struct PlaceDTO: Codable { let id: Int16, name: String, address: String?, latitude: Double, longitude: Double, createdAt: Date }
struct MembershipDTO: Codable { let id: Int16, createdAt: Date, userId: Int16, groupId: Int16 }
struct SharedPlaceDTO: Codable { let id: Int16, createdAt: Date, sharedById: Int16, groupId: Int16, placeId: Int16 }
struct DefaultsDTO: Codable { let suggestedDefaultUserId: Int16 }
