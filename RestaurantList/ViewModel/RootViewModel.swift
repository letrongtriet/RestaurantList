//
//  RootViewModel.swift
//  RestaurantList
//
//  Created by Le, Triet on 9.12.2020.
//

import UIKit
import Foundation
import Combine
import CoreLocation

enum State {
    case starting
    case fetching
    case error(String)
    case fetched([RestaurantItem])
    case empty(String)
}

class RootViewModel {

    // MARK: - Observables
    @Published public private(set) var state: State

    // MARK: - Public properties
    private var bag = Set<AnyCancellable>()
    private var timer: Timer?

    // MARK: - Private properties
    private let networkManager: NetworkManager
    private let userDefaultsManager: UserDefaultsManager

    private var coordinates: [CLLocationCoordinate2D] {
        return [
            CLLocationCoordinate2D(latitude: 60.170187, longitude: 24.930599),
            CLLocationCoordinate2D(latitude: 60.169418, longitude: 24.931618),
            CLLocationCoordinate2D(latitude: 60.169818, longitude: 24.932906),
            CLLocationCoordinate2D(latitude: 60.170005, longitude: 24.935105),
            CLLocationCoordinate2D(latitude: 60.169108, longitude: 24.936210),
            CLLocationCoordinate2D(latitude: 60.168355, longitude: 24.934869),
            CLLocationCoordinate2D(latitude: 60.167560, longitude: 24.932562),
            CLLocationCoordinate2D(latitude: 60.168254, longitude: 24.931532),
            CLLocationCoordinate2D(latitude: 60.169012, longitude: 24.930341),
            CLLocationCoordinate2D(latitude: 60.170085, longitude: 24.929569)
        ]
    }

    private var favoriteIds: [String] {
        userDefaultsManager.getFavoriteIds()
    }

    private var currentRestaurants = [Restaurant]()

    private var currentIndex: Int = 0
    private var increasement: Int = 1

    // MARK: - Init
    init(networkManager: NetworkManager) {
        self.state = .starting
        self.networkManager = networkManager
        self.userDefaultsManager = UserDefaultsManager()
        binding()
    }

    // MARK: - Public methods
    func remove(id: String) {
        userDefaultsManager.remove(id: id)
        transformData(currentRestaurants)
    }

    func add(id: String) {
        userDefaultsManager.add(id: id)
        transformData(currentRestaurants)
    }

    // MARK: - Private methods
    private func binding() {
        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .sink(receiveValue: { [weak self] _ in
                self?.start()
            }).store(in: &bag)

        NotificationCenter.default
            .publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink(receiveValue: { [weak self] _ in
                self?.stop()
            }).store(in: &bag)
    }

    private func start() {
        fetchWithCurrentIndex()
        startTimer()
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { [weak self] _ in
            self?.fetchWithCurrentIndex()
        })
    }

    private func fetchWithCurrentIndex() {
        print("Fetch")
        fetchRestaurantsWith(coordinate: coordinates[currentIndex])

        if currentIndex == 9 {
            increasement = -1
        }

        if currentIndex == 0 {
            increasement = 1
        }

        currentIndex += increasement
    }

    private func fetchRestaurantsWith(coordinate: CLLocationCoordinate2D) {
        state = .fetching

        networkManager
            .getRestaurants(coordinate: coordinate)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.handleError(error)
                default:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.handleResponse(response)
            }
            .store(in: &bag)
    }

    private func handleResponse(_ response: APIResponse?) {
        guard let response = response else {
            state = .empty("Your current location is not supported yet")
            return
        }
        currentRestaurants = Array(response.restaurants[0..<15])
        transformData(currentRestaurants)
    }

    private func transformData(_ restaurants: [Restaurant]) {
        var toRet = [RestaurantItem]()
        restaurants.forEach { restaurant in
            toRet.append(
                RestaurantItem(restaurant: restaurant,
                               isFavorite: favoriteIds.contains(restaurant.id.oid)))
        }
        state = .fetched(toRet)
    }

    private func handleError(_ error: Error) {
        state = .error(error.localizedDescription)
    }

}
