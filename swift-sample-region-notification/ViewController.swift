//
//  ViewController.swift
//  swift-sample-region-notification
//
//  Created by Liling Chen on 2019/08/20.
//  Copyright © 2019 CCBJI. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // setup Map View
        let noLocation = CLLocationCoordinate2D()
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let viewRegion = MKCoordinateRegion(center: noLocation, span: span)
        
        mapView.delegate = self
        mapView.region = viewRegion
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        setupMapView()
    }
    
    func setupMapView(){
        
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            
            var annotationList = [MKPointAnnotation]()
            var circleList = [MKCircle]()
            
            let locationName = "Tokyo Tower"
            let coordiate = CLLocationCoordinate2DMake(35.658626, 139.745471)
            
            // setup annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordiate
            annotation.title = locationName
            
            annotationList.append(annotation)
            
            // setup circle
            let circle = MKCircle(center: coordiate, radius: 50)
            circleList.append(circle)
            
            // add to map view
            mapView.addAnnotations([annotation])
            mapView.addOverlays([circle])
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView.region = region
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor(red: 66/255, green: 133/255, blue: 244/255, alpha: 0.80)
        circleRenderer.lineWidth = 1.0
        circleRenderer.fillColor = UIColor(red: 66/255, green: 133/255, blue: 244/255, alpha: 0.20)
        
        return circleRenderer
    }
}

