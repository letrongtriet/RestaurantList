//
//  Restaurant.swift
//  RestaurantList
//
//  Created by Le, Triet on 9.12.2020.
//

import Foundation

// MARK: - Welcome
struct APIResponse: Codable {
    let restaurants: [Restaurant]

    enum CodingKeys: String, CodingKey {
        case restaurants = "results"
    }
}

// MARK: - Restaurant
struct Restaurant: Codable {
    let id: Id
    let listimage: String
    let name: [LocalizedValue]
    let shortDescription: [LocalizedValue]

    enum CodingKeys: String, CodingKey {
        case id, name, listimage
        case shortDescription = "short_description"
    }
}

// MARK: - Id
struct Id: Codable {
    let oid: String

    enum CodingKeys: String, CodingKey {
        case oid = "$oid"
    }
}

// MARK: - LocalizedValue
struct LocalizedValue: Codable {
    let lang: String
    let value: String
}

// MARK: - RestaurantItem
struct RestaurantItem {
    let restaurant: Restaurant
    let isFavorite: Bool
}
