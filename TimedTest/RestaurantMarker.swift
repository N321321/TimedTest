//
//  RestaurantMarker.swift
//  TimedTest
//

//  Copyright © 2019 Nikolaus400. All rights reserved.
//

import Foundation
import MapKit
class RestaurantMarker: NSObject, MKAnnotation
{
    //this class is needed because we are using Apple maps, certain variable names and inheritances needed to satisfy MKMapViewDelegate protocol
    
    var title: String?
    let coordinate: CLLocationCoordinate2D
    
    let restaurant:Restaurant;
    
    init(restaurant:Restaurant)
    {
        self.restaurant = restaurant;
        
        self.title = restaurant.name;
        
        coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude);
    }
    
}
