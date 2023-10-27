//
//  LocationDAO.swift
//  AppInmaBautista
//
//  Created by ibautista on 26/10/23.
//

import Foundation
import CoreData

typealias LocationsDAO = [LocationDAO]

@objc(LocationDAO)
class LocationDAO: NSManagedObject {
    static let entityName = "LocationDAO"
    
    @NSManaged var id: String?
    @NSManaged var date: String?
    @NSManaged var longitude: String?
    @NSManaged var latitude: String?
    @NSManaged var heroId: String?
//    @NSManaged var heroName: String?
}
