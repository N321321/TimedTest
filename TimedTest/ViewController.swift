//
//  ViewController.swift
//  TimedTest
//

//  Copyright © 2019 Nikolaus400. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, ModelDelegate {
   
    
    
    @IBOutlet var mapView: MKMapView!
    
    let model:Model = Model();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       mapView.delegate = self;
       
    model.setModelDelegateAndGetData(modelDelegate: self)
        
       
        
    }
    
 
 
    
    func dataReceived(data: [Restaurant]?)
    {
        
        if let restaurants:[Restaurant] = data
        {
         
            var markers:[MKAnnotation] = [MKAnnotation]();
            
            for restaurant in restaurants
            {
                //the class RestaurantMarker is used to create markers (with restaurant data) that meets map protocol
                markers.append(RestaurantMarker(restaurant: restaurant));
            }
            
            
            mapView.addAnnotations(markers)
            
           
            
                    DispatchQueue.main.async {
                        //update main thread this way
                        [unowned self] in
                        self.updateMapView(markers: markers)
                    }
            
        }else
        {
            print("Error, no valid data returned")
        }
        
        
    }
    
    @objc func updateMapView(markers:[MKAnnotation])
    {

        mapView.showAnnotations(markers, animated: true);
    }
    
  
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        //this is a delegate method for the mapView. It  returns the view for the annotation(marker) with the detail information button configured to show

        guard let annotation = annotation as? RestaurantMarker else {return nil}

        let identifier = "marker"

         var view:MKAnnotationView

        if #available(iOS 11.0, *)
        {


            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            {
                dequeuedView.annotation = annotation;
                view = dequeuedView;
                view.clusteringIdentifier = nil
                view.displayPriority = MKFeatureDisplayPriority.required;

            }else
            {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                view.clusteringIdentifier = nil
                view.displayPriority = MKFeatureDisplayPriority.required;
            }

        }
        else
        {
            // Fallback on earlier versions


            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            {
                dequeuedView.annotation = annotation;
                view = dequeuedView;
            }else
            {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                
            }


        }



         return view;

    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //delegate method which allows us to set action to take when detail information button is pressed
        
        
      if let restaurantMarker = view.annotation as? RestaurantMarker
      {
        let storyboard = UIStoryboard(name: "RestaurantDetailScreen", bundle: nil)
        
        let RestaurantDetailScreen = storyboard.instantiateViewController(withIdentifier: "RestaurantDetailScreen") as? RestaurantDetailScreenViewController
        
        RestaurantDetailScreen?.restaurant = restaurantMarker.restaurant
        self.present(RestaurantDetailScreen!, animated: false, completion: nil)
        
        }
        
        
    
        
    }
    


}

