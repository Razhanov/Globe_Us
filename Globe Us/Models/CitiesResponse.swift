//
//  CitiesResponse.swift
//  Globe Us
//
//  Created by Karim Razhanov on 14.09.2020.
//

import Foundation

// MARK: - Cities
struct Cities: Codable {
    let status, message: String
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let title: String
    let images: [String]
    let createdAt, updatedAt: String
    let countryID: Int
    let country: Country
    let places: [Place]

    enum CodingKeys: String, CodingKey {
        case id, title, images, createdAt, updatedAt
        case countryID = "CountryId"
        case country = "Country"
        case places = "Places"
    }
}

// MARK: - Country
struct Country: Codable {
    let id: Int
    let title: String
    let createdAt, updatedAt: String
    let langID: Int

    enum CodingKeys: String, CodingKey {
        case id, title, createdAt, updatedAt
        case langID = "LangId"
    }
}

// MARK: - Place
struct Place: Codable {
    let id: Int
    let title, nativeTitle, code: String
    let images: [String]
    let lat, long, placeDescription, createdAt: String
    let updatedAt: String
    let cityID: Int

    enum CodingKeys: String, CodingKey {
        case id, title, nativeTitle, code, images, lat, long
        case placeDescription = "description"
        case createdAt, updatedAt
        case cityID = "CityId"
    }
}
