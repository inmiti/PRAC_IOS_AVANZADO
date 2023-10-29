//
//  Hero.swift
//  AppInmaBautista
//
//  Created by ibautista on 23/10/23.
//

import Foundation

public typealias Heroes = [Hero]

public struct Hero: Codable {
    let id: String?
    let name: String?
    let description: String?
    let photo: URL?
    let favorite: Bool?
}
