//
//  MapViewController.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 2/19/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let map = MKMapView()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add as a subivew
        //Set up properties
        //Set up constraints
        //view.addSubview(map)
        view.backgroundColor = .blue
        view.isHidden = false
        print("working")
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//        locationManager.distanceFilter = 20
//
//
//        map.showsUserLocation = true
//        let region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
//        map.setRegion(region, animated: true)
//        map.delegate = self
//
//        map.translatesAutoresizingMaskIntoConstraints = true
//        map.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//        map.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
//        map.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
//        map.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        
        
        
    }
    
    


}
