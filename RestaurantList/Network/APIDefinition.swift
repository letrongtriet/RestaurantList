//
//  APIDefinition.swift
//  RestaurantList
//
//  Created by Le, Triet on 9.12.2020.
//

import Foundation
import CoreLocation

typealias ReaquestHeaders = [String: String]
typealias RequestParameters = [String : Any?]
typealias Closure<T> = (T) -> Void

protocol APIRequestProtocol {
    var path: String { get }
    var method: RequestMethod { get }
    var headers: ReaquestHeaders? { get }
    var parameters: RequestParameters? { get }
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error, Equatable {
    case noData
    case challenge
    case invalidResponse
    case badRequest(String?)
    case serverError(String?)
    case parseError(String?)
    case unknown
}

public enum RestaurantAPI: APIRequestProtocol {
    case retaurants(coordinate: CLLocationCoordinate2D)
}
