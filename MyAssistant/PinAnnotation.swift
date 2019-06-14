//
//  PinAnnotation.swift
//  MyAssistant
//
//  Created by user on 12/6/17.
//  Copyright © 2017 Vignesh. All rights reserved.
//

import MapKit

class PinAnnotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, location:CLLocationCoordinate2D){
        self.title = title
        self.subtitle = subtitle
        self.coordinate = location
    }
}
