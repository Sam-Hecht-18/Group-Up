//
//  EventLocationCreatorViewController.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 4/1/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import MapKit

class EventLocationCreatorViewController: UIViewController, MKMapViewDelegate {
    let mapView = MKMapView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        view.addSubview(mapView)
        mapView.showsUserLocation = true
        let region = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025))
        mapView.setRegion(region, animated: true)
        
        mapView.delegate = self
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        mapView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: view.frame.height - 100).isActive = true
        let confirmButton = UIBarButtonItem(title: "Confirm Location", style: .done, target: self, action: #selector(confirm))
        
        navigationItem.rightBarButtonItem = confirmButton
        //confirmButton.setTitle("Confirm", for: .normal)
        //        view.addSubview(confirmButton)
        //        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        //        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 160).isActive = true
        //        confirmButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -340).isActive = true
        //        confirmButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        //        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapWasTapped(gestureRecognizer:)))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        print("never again")
        // Do any additional setup after loading the view.
    }
    @objc func confirm(){
        print("cmon man")
        print("EHRA")
        navigationController?.popViewController(animated: true)
    }
    @objc func mapWasTapped(gestureRecognizer: UIGestureRecognizer){
        mapView.removeAnnotations(mapView.annotations)
        let touchPoint = gestureRecognizer.location(in: mapView)
        location = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let myEvent = Event()
        myEvent.coordinate = location
        mapView.addAnnotation(myEvent)
        navigationItem.rightBarButtonItem?.isEnabled = true
        print("ya huh")
        print("UFNSKID")
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
