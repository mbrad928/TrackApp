//
//  Track.swift
//  TrackApp
//
//  Created by Max Bradley on 7/22/16.
//  Copyright © 2016 Max Bradley. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import Firebase

struct Track {
    var key: String?
    var description: String?
    var latitude: Double?
    var longitude: Double?
    var radius: Int?

    init(desc: String?, lat: Double?, lon: Double?, radius: Int){
        self.description = desc
        self.latitude = lat
        self.longitude = lon
        self.radius = radius
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        print (snapshot.value!["Neighborhood"])
        self.description = snapshot.value!["Description"] as? String
        print (self.key)
        self.radius = snapshot.value!["Radius"] as? Int
        self.latitude = snapshot.value!["Latitude"] as? Double
        self.longitude = snapshot.value!["Longitude"] as? Double

    }

}
