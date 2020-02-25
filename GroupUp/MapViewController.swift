//
//  MapViewController.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 2/19/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import MapKit

class customPin: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(pinTitle: String, pinSubtitle: String, location: CLLocationCoordinate2D){
        self.title = pinTitle
        self.subtitle = pinSubtitle
        self.coordinate = location
    }
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var timeAndDistance = String()
    let map = MKMapView()
    let locationManager = CLLocationManager()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add as a subivew
        //Set up properties
        //Set up constraints
        view.addSubview(map)
        setUpMapView()
        checkLocationServices()
        //40.0102° N, 75.2797° W
        let location = CLLocationCoordinate2D(latitude: 40.0423, longitude: -75.3167)
        map.addAnnotation(customPin(pinTitle: "Harriton", pinSubtitle: "", location: location))
        
        
    }
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            checkLocationAuthorization()
            setUpLocationManager()
        }
    }
    func checkLocationAuthorization(){
        
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        // break
        case .restricted:
            //Show alert instructing them how to turn on permissions
            break
        case .authorizedAlways:
            
            break
        @unknown default:
            break
        }
        
        
    }
    func setUpLocationManager(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 20
        
    }
    func setUpMapView(){
        
        map.showsUserLocation = true
        let region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        map.setRegion(region, animated: true)
        
        map.delegate = self
        
        map.translatesAutoresizingMaskIntoConstraints = false
        map.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        map.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        map.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        map.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("You updated yo location")
        
        let region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.33182, longitude: -122.03118), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        
        map.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("BRUV")
        if let polyline = overlay as? MKPolyline{
            let render = MKPolylineRenderer(overlay: polyline)
            render.strokeColor = .purple
            return render
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //Checks to make sure you're not clicking on your own location
         if view.annotation?.coordinate.latitude != mapView.userLocation.coordinate.latitude && view.annotation?.coordinate.longitude != mapView.userLocation.coordinate.longitude{
            
            
            
            let destCoordinate = view.annotation?.coordinate ?? CLLocationCoordinate2D()
            let sourceCoordinate = locationManager.location?.coordinate ?? CLLocationCoordinate2D()
            
            let sourcePlaceMark = MKPlacemark(coordinate: sourceCoordinate)
            let destPlaceMark = MKPlacemark(coordinate: destCoordinate)
            
            let sourceItem = MKMapItem(placemark: sourcePlaceMark)
            let destItem = MKMapItem(placemark: destPlaceMark)
            
            let destinationRequest = MKDirections.Request()
            destinationRequest.source = sourceItem
            destinationRequest.destination = destItem
            destinationRequest.transportType = .automobile
            destinationRequest.requestsAlternateRoutes = false
            
            let directions = MKDirections(request: destinationRequest)
            resetMapView(withNew: directions)
            
            directions.calculate { (response, error) in
                guard let response = response else{
                    if error != nil{
                        print("Something is wrong :(")
                    }
                    return
                }
                let route = response.routes[0]
                
                var eta: Int = Int(route.expectedTravelTime)
                //print("The travel time is: \(eta)")
                eta /= 60
                
                self.getETA(withETA: eta)
                self.getDistance(withDistance: Int(route.distance))
                
                
                
                self.map.addOverlay(route.polyline)
                self.resetMapViewBounds(withNew: route)
                
            }
        }
    }
    
    func getETA(withETA eta : Int){
        var etaMutable = eta
        if etaMutable > 60  {
            self.timeAndDistance.append("\(etaMutable/60) hr ")
            etaMutable -= eta/60 * 60
        }
        self.timeAndDistance.append("\(etaMutable) min ")
        
    }
    
    func getDistance(withDistance distance : Int){
        let goodDistance = Int(Double(distance) / 1609.34)
        timeAndDistance.append("(\(goodDistance) mi)")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if !map.overlays.isEmpty{
            map.removeOverlays(map.overlays)
        }
    }
    func resetMapViewBounds(withNew route : MKRoute){
        let x = route.polyline.boundingMapRect.minX - route.polyline.boundingMapRect.width/8.0
        let y = route.polyline.boundingMapRect.minY - route.polyline.boundingMapRect.height/8.0
        let width = route.polyline.boundingMapRect.width + route.polyline.boundingMapRect.width/4.0
        let height = route.polyline.boundingMapRect.height + route.polyline.boundingMapRect.height/3.0
        
        let visibleBounds = MKMapRect(x:x,y:y,width:width,height:height)
        //self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        self.map.setVisibleMapRect(visibleBounds, animated: true)
    }
    
    func resetMapView(withNew directions: MKDirections){
        if !map.overlays.isEmpty{
            map.removeOverlays(map.overlays)
        }
        directions.cancel()
        
        
    }
    
}
