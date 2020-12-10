//
//  APIImplementation.swift
//  RestaurantList
//
//  Created by Le, Triet on 9.12.2020.
//

import Foundation

extension RestaurantAPI {
    var path: String {
        switch self {
        case let .retaurants(coordinate):
            return "/v3/venues?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .retaurants:
            return .get
        }
    }

    var headers: ReaquestHeaders? {
        nil
    }

    var parameters: RequestParameters? {
        nil
    }
}
