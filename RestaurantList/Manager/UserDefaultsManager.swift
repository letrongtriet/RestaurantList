//
//  UserDefaultsManager.swift
//  RestaurantList
//
//  Created by Le, Triet on 10.12.2020.
//

import Foundation

class UserDefaultsManager {
    func getFavoriteIds() -> [String] {
        UserDefaults.standard.stringArray(forKey: UserDefaultsKey.favoriteIds) ?? [String]()
    }

    func add(id: String) {
        var currentFavoriteIds = getFavoriteIds()
        guard !currentFavoriteIds.contains(id) else { return }
        currentFavoriteIds.append(id)
        UserDefaults.standard.set(currentFavoriteIds, forKey: UserDefaultsKey.favoriteIds)
    }

    func remove(id: String) {
        let currentFavoriteIds = getFavoriteIds()
        guard currentFavoriteIds.contains(id) else { return }
        let newArray = currentFavoriteIds.filter({ $0 != id })
        UserDefaults.standard.set(newArray, forKey: UserDefaultsKey.favoriteIds)
    }
}
