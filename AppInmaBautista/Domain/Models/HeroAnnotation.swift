//
//  HeroAnnotation.swift
//  AppInmaBautista
//
//  Created by ibautista on 28/10/23.
//

import Foundation
import MapKit

class HeroAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var info: String?
    
    init(title: String? = nil, info: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.info = info
        self.coordinate = coordinate
    }
}
