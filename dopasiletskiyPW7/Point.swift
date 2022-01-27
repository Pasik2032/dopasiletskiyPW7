//
//  Point.swift
//  dopasiletskiyPW7
//
//  Created by Даниил Пасилецкий on 27.01.2022.
//

import Foundation
import MapKit

class NavigetorPoint: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, text: String){
        self.coordinate = coordinate
        title = text
    }
}
