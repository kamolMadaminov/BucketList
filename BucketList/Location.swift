//
//  Location.swift
//  BucketList
//
//  Created by Kamol Madaminov on 08/04/25.
//

import Foundation
import MapKit

struct Location: Codable, Identifiable, Equatable {
    var id: UUID
    var name: String
    var description: String
    var longitude: Double
    var latitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    #if DEBUG
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Lit by over 40.000 lights", longitude: 51.501, latitude: -0.141)
    #endif
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
