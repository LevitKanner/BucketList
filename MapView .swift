//
//  MapView .swift
//  BucketList
//
//  Created by Levit Kanner on 01/12/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    var annotations: [MKPointAnnotation]
    @Binding var selectedPlace: MKPointAnnotation?
    @Binding var showingPlaceDetails: Bool 
    
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        if annotations.count != uiView.annotations.count{
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
        }
    }
    
    
    
    
    
    ///Coordinator class for passing data
    class Coordinator: NSObject , MKMapViewDelegate{
        let parent: MapView
        
        init(_ parent: MapView){
            self.parent = parent
        }
        
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
        //Gets called whenever the rightCalloutAccessory is tapped
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let placeMark = view.annotation as? MKPointAnnotation else {return}
            parent.selectedPlace = placeMark
            parent.showingPlaceDetails = true
        }
        
        
        
        //Customizes the way the marker looks
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "PlaceMark"
            var annotationview = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationview == nil {
                annotationview = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                
                annotationview?.canShowCallout = true
                
                annotationview?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }else {
                annotationview?.annotation = annotation
            }
            
            return annotationview
            
        }
    }
    
    
    
    
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
    
}
