//
//  NetworkManager.swift
//  RestaurantList
//
//  Created by Le, Triet on 9.12.2020.
//

import Foundation
import Combine
import CoreLocation

public final class NetworkManager {

    // MARK: - Private properties
    private let baseUrlString: String

    // MARK: - Init
    init(baseUrlString: String) {
        self.baseUrlString = baseUrlString
    }

    // MARK: - Public methods
    func getRestaurants(coordinate: CLLocationCoordinate2D) -> AnyPublisher<APIResponse?, Error> {
        if let request = createURLRequest(from: RestaurantAPI.retaurants(coordinate: coordinate)) {
            return run(request)
        }

        return Just(nil).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    // MARK: - Private methods
    private func run<T: Codable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> T in
                return try JSONDecoder().decode(T.self, from: result.data)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func createURLRequest(from requestType: APIRequestProtocol) -> URLRequest? {
        let urlString = baseUrlString + requestType.path

        guard let url = URL(string: urlString) else {
            return nil
        }

        var request = URLRequest(url: url, timeoutInterval: 60)
        request.httpMethod = requestType.method.rawValue

        if let parameters = requestType.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        if let headers = requestType.headers {
            request.allHTTPHeaderFields = headers
        }

        return request
    }

}
