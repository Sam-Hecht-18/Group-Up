//
//  MapViewController.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 2/19/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//



import UIKit
import MapKit
import FirebaseAuth
import UserNotifications

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    
    
    var timeAndDistance = String()
    let eventManagerSlideUpView = EventManagerSlideUpViewController()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(map)
        setUpMapView()
        checkLocationServices()
        
        checkLogIn()
        retrieveFriendsAndUsers()
        
        
        
        
        
        setUpNavigationControllerBackground()
        
        
        let eventCreatorButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(buttonClicked(_:)))
        
        
        navigationItem.rightBarButtonItem = eventCreatorButton
        addEventManagerSlideUpViewController()
        
        
        
        
        
    }
    
    func setUpNavigationControllerBackground(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
    }
    
    func checkLogIn(){
        if Auth.auth().currentUser == nil{
            transitiontoNewVC(.logOut, currentViewController: self)
        }
        else{
            downloadPicture()
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            checkLocationAuthorization()
            setUplocationManage()
        }
    }
    
    func checkLocationAuthorization(){
        
        switch CLLocationManager.authorizationStatus(){
        case .authorizedWhenInUse:
            locManager.startUpdatingLocation()
            break
        case .denied:
            //Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locManager.requestWhenInUseAuthorization()
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
    
    
    func setUplocationManage(){
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestAlwaysAuthorization()
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        locManager.distanceFilter = 20
        
    }
    
    func setUpMapView(){
        
        map.showsUserLocation = true
        let region = MKCoordinateRegion(center: locManager.location?.coordinate ?? CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        map.setRegion(region, animated: true)
        
        map.delegate = self
        
        map.translatesAutoresizingMaskIntoConstraints = false
        map.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        map.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        map.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        map.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let region = MKCoordinateRegion(center: locManager.location?.coordinate ?? CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        
        map.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline{
            let render = MKPolylineRenderer(overlay: polyline)
            render.strokeColor = strokeColor
            return render
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //Checks to make sure you're not clicking on your own location
        if view.annotation?.coordinate.latitude == mapView.userLocation.coordinate.latitude && view.annotation?.coordinate.longitude == mapView.userLocation.coordinate.longitude{
            print("this happened")
            return
        }
        
        print("right")
        var beginString = ""
        if view.tag == 0{
            beginString = "Red Pin"
            strokeColor = UIColor(red: 201/255.0, green: 26/255.0, blue: 31/255.0, alpha: 1.0)
        }
        else if(view.tag == 1){
            beginString = "Blue Pin"
            strokeColor = UIColor(red: 65/255.0, green: 95/255.0, blue: 196/255.0, alpha: 1.0)
        }
        else{
            beginString = "Yellow Pin"
            strokeColor = UIColor(red: 208/255.0, green: 222/255.0, blue: 39/255.0, alpha: 1.0)
        }
        view.image = UIImage(named: "\(beginString) Big")!
        
        
        
        let destCoordinate = view.annotation?.coordinate ?? CLLocationCoordinate2D()
        let sourceCoordinate = locManager.location?.coordinate ?? CLLocationCoordinate2D()
        
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
            
            var eta: Double = route.expectedTravelTime
            print(route.expectedTravelTime)
            //print("The travel time is: \(eta)")
            eta /= 60.0
            eta.round(.toNearestOrAwayFromZero)
            print(eta)
            self.getETA(withETA: Int(eta))
            self.getDistance(withDistance: Int(route.distance))
            
            self.eventManagerSlideUpView.updateTimeAndDistanceLabel(self.timeAndDistance)
            
            guard let event = view.annotation as? Event else {return}
            self.eventManagerSlideUpView.updateEventSelected(event)
            self.eventManagerSlideUpView.popUpViewToMiddle()
            self.timeAndDistance = String()
            map.addOverlay(route.polyline)
            //self.resetMapViewBounds(withNew: route)
            
        }
    }
    
    
    func getETA(withETA eta : Int){
        var etaMutable = eta
        if etaMutable > 60  {
            self.timeAndDistance.append("\(etaMutable/60) hr ")
            etaMutable -= eta/60 * 60
        }
        self.timeAndDistance.append("\(etaMutable) min\n")
        
    }
    
    func getDistance(withDistance distance : Int){
        var goodDistance = Double(distance) / 1609.34
        print(goodDistance)
        goodDistance *= 10
        goodDistance.round(.toNearestOrAwayFromZero)
        goodDistance /= 10
        timeAndDistance.append("\(goodDistance) miles")
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.coordinate.latitude == mapView.userLocation.coordinate.latitude && annotation.coordinate.longitude == mapView.userLocation.coordinate.longitude{
            print("this happened")
            return nil
        }
        let annotationView = MKAnnotationView()
        annotationView.canShowCallout = true
        //let nameLabel = UILabel()
        //nameLabel.text = annotation.title ?? ""
        // annotationView.detailCalloutAccessoryView = nameLabel
        annotationView.calloutOffset = CGPoint(x: 8, y: 0)
        annotationView.annotation = annotation
        guard let event = annotation as? Event else {return annotationView}
        switch event.activity{
        case "Athletic":
            annotationView.image = UIImage(named: "Red Pin Small")!
            annotationView.tag = 0
            break
        case "Scholarly":
            annotationView.image = UIImage(named: "Blue Pin Small")!
            annotationView.tag = 1
            break
        default:
            annotationView.image = UIImage(named: "Yellow Pin Small")!
            annotationView.tag = 2
        }
        
        
        return annotationView
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation?.coordinate.latitude == mapView.userLocation.coordinate.latitude && view.annotation?.coordinate.longitude == mapView.userLocation.coordinate.longitude{
            print("this happened")
            return
        }
        print("left")
        var beginString = "Red Pin"
        if(view.tag == 1){
            beginString = "Blue Pin"
        }
        else if(view.tag == 2){
            beginString = "Yellow Pin"
        }
        view.image = UIImage(named: "\(beginString) Small")!
        if !map.overlays.isEmpty{
            map.removeOverlays(map.overlays)
        }
        
        eventManagerSlideUpView.updateTimeAndDistanceLabel("")
        eventManagerSlideUpView.unpopulate()
        eventManagerSlideUpView.popUpViewToBottom()
    }
    
    func resetMapViewBounds(withNew route : MKRoute){
        let x = route.polyline.boundingMapRect.minX - route.polyline.boundingMapRect.width/8.0
        let y = route.polyline.boundingMapRect.minY - route.polyline.boundingMapRect.height/8.0
        let width = route.polyline.boundingMapRect.width + route.polyline.boundingMapRect.width/4.0
        let height = route.polyline.boundingMapRect.height + route.polyline.boundingMapRect.height/3.0
        
        let visibleBounds = MKMapRect(x:x,y:y,width:width,height:height)
        //self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        map.setVisibleMapRect(visibleBounds, animated: true)
    }
    
    func resetMapView(withNew directions: MKDirections){
        if !map.overlays.isEmpty{
            map.removeOverlays(map.overlays)
        }
        directions.cancel()
        
        
    }
    
    
    func addEventManagerSlideUpViewController(){
        
        // 2- Add eventManagerSlideUpView as a child view
        self.addChild(eventManagerSlideUpView)
        view.addSubview(eventManagerSlideUpView.view)
        view.bringSubviewToFront(eventManagerSlideUpView.view)
        eventManagerSlideUpView.didMove(toParent: self)
        // 3- Adjust event manager frame and initial position.
        let height = view.frame.height
        let width  = view.frame.width
        eventManagerSlideUpView.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    @IBAction func SidebarButtonTapped(_ sender: UIBarButtonItem) {
        slideOutSidebar(self)
    }
    
    @objc func buttonClicked(_ : UIButton){
        let eventViewController = EventCreator()
        navigationController?.pushViewController(eventViewController, animated: true)
        //self.present(eventViewController, animated: true, completion: nil)
    }
    
    
}
