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


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    
    
    var timeAndDistance = String()
    let eventCreator = UIButton(type: .custom)
    let locationManager = CLLocationManager()
    let eventManagerSlideUpView = EventManagerSlideUpViewController()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpObservers()
        //overrideUserInterfaceStyle = .dark
        view.addSubview(map)
        setUpMapView()
        checkLocationServices()
       
        checkLogIn()
        
        setUpNavigationControllerBackground()
        
        //databaseRef.child("users/\(Auth.auth().currentUser?.uid!)")
        retrieveUsers()
        
        eventCreator.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        
        eventCreator.titleLabel?.lineBreakMode = .byWordWrapping
        eventCreator.titleLabel?.textAlignment = .center
        eventCreator.setAttributedTitle(NSAttributedString(string: "Create\nEvent", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]), for: .normal)
        eventCreator.frame = CGRect(x: 0, y: 0, width: 70, height: 50)
        eventCreator.setTitleColor(.black, for: .normal)
       
        eventCreator.backgroundColor = .white
        eventCreator.setTitleColor(.black, for: .normal)

//        eventCreator.clipsToBounds = true
        eventCreator.layer.cornerRadius = 10
        
        let plz = UIBarButtonItem(customView: eventCreator)
        navigationItem.rightBarButtonItem = plz
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
//    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        let width = map.region.span.longitudeDelta
//        let height = map.region.span.latitudeDelta
//        let startLong = map.region.center.longitude - width/2
//        let startLat = map.region.center.latitude + height/2
//        print(width)
//        print(height)
//        print(startLat)
//        print(startLong)
//
//
//    }
    
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
        
        let region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        
        map.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline{
            let render = MKPolylineRenderer(overlay: polyline)
            render.strokeColor = .purple
            return render
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //Checks to make sure you're not clicking on your own location
        print("right")
        if view.annotation?.coordinate.latitude != mapView.userLocation.coordinate.latitude && view.annotation?.coordinate.longitude != mapView.userLocation.coordinate.longitude{
            
            //eventManagerSlideUpView.popUpViewToMiddle()
            
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
        var goodDistance = Double(distance) / 1609.34
        print(goodDistance)
        goodDistance *= 10
        goodDistance.round(.toNearestOrAwayFromZero)
        goodDistance /= 10
        timeAndDistance.append("(\(goodDistance) mi)")
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("left")
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
