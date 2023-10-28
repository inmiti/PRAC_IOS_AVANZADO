//
//  Locations.swift
//  AppInmaBautista
//
//  Created by ibautista on 26/10/23.
//

import Foundation

typealias Locations = [Location]

struct Location: Codable {
    
    enum CodingKeys: String, CodingKey{
        case id
        case date = "dateShow"
        case longitude = "longitud"
        case latitude = "latitud"
        case hero
    }
    
    let id: String?
    let date: String?
    let longitude: String?
    let latitude: String?
    let hero: Hero?
}

