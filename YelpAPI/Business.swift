//
//  Business.swift
//  YelpAPI
//
//  Created by Daniel Lau on 8/5/18.
//  Copyright © 2018 Daniel Lau. All rights reserved.
//

import Foundation

struct Yelp: Codable {

    let total : Int
    let businesses : [Business]
}


struct Business : Codable {
    let name : String
    let coordinates : Coordinates
    let location : Location
}

struct Coordinates : Codable {
    let latitude : Double
    let longitude: Double
}

struct Location : Codable {

    let address1 : String
    let city : String
    let zipCode : String
    let state : String
    
    enum CodingKeys: String, CodingKey {
        case address1
        case city
        case state
        case zipCode = "zip_code"
    }
}

