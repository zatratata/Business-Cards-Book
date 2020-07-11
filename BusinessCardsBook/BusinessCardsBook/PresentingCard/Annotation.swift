//
//  Annotation.swift
//  BusinessCardsBook
//
//  Created by Николай Подгайский on 7/11/20.
//  Copyright © 2020 Padhaiski Nikolay. All rights reserved.
//

import Foundation
import MapKit   

class Annotation: NSObject, MKAnnotation {
   
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    internal init(title: String? = nil, subtitle: String? = nil, coordinate: CLLocationCoordinate2D) {
           self.title = title
           self.subtitle = subtitle
           self.coordinate = coordinate
       }
}
