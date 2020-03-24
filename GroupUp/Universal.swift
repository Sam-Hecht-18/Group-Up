import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit
import MapKit

//  Universal.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 3/10/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//
var databaseRef = Database.database().reference()
var storageRef = Storage.storage().reference()
var events: [Event] = []
let map = MKMapView()
let transition = SlideInTransition()
let universe = Universal()
var userImage: UIImage?







func updateEvents(){
    map.addAnnotation(events[events.count-1])
}

func setUpObserver(){
    let observer1 = databaseRef.child("events").observe(.value) { (allEvents) in
        print("you're in here")
        print(allEvents.childrenCount)
        events.removeAll()
        map.removeAnnotations(map.annotations)
        for event in allEvents.children{
            guard let event = event as? DataSnapshot else {return}
            guard let eventInformation = event.value as? NSDictionary else {return}

            print("1")
            guard let ownerString = eventInformation["owner"] as? String else {return}
            print("2")
            guard let joinedArray = eventInformation["joined"] as? [String] else {return}
            print("3")
            guard let timeString = eventInformation["time"] as? String else {return}
            print("4")
            guard let name = eventInformation["title"] as? String else {return}
            print("5")
            guard let latitudeString = eventInformation["latitude"] as? String else {return}
            print("6")
            guard let longitudeString = eventInformation["longitude"] as? String else {return}
            print("7")
            guard let latitudeDouble = Double(latitudeString) else {return}
            guard let longitudeDouble = Double(longitudeString) else {return}
            let location = CLLocationCoordinate2D(latitude: latitudeDouble, longitude: longitudeDouble)
            
            guard let timeInterval = Double(timeString) else {return}
            let time = Date(timeIntervalSinceReferenceDate: timeInterval)
            print(name)
            let myEvent = Event(title: name, owner: ownerString, coordinate: location, time: time, joined: joinedArray)
            events.append(myEvent)
            updateEvents()
            print("theres no way in hell")
            
        }
    }

}

func getProfilePic(){
    guard let uid = Auth.auth().currentUser?.uid else {return}
    storageRef.child("Profile Pic /\(uid)").getData(maxSize: 1024*1024) { (data, error) in
        guard let unwrappedData = data else {return}
        userImage = UIImage(data: unwrappedData)
        if error != nil {
            print("You have no pic lmao")
        }
        else{
            print("I mean you're here...")
        }
    }
}

func transitiontoNewVC(_ menuType: MenuType, currentViewController: UIViewController){
    //I have a feeling that we'll want to pop to the root before doing any other thing
    //Might have to change the animation stuff tho cuz we won't want the user seeing that
    //This would mean that we uncomment the line below
    //And get rid of the .map case
    //Task for another day
    
    //currentViewController.navigationController?.popToRootViewController(animated: true)
    switch menuType{
    case .map:
        currentViewController.navigationController?.popToRootViewController(animated: true)
    case .profile:
        guard let profileViewController = currentViewController.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") else {return}
        currentViewController.navigationController?.pushViewController(profileViewController, animated: true)
    case .logOut:
        do{
            try Auth.auth().signOut()
        }
        catch{
            print("shoot")
        }
        map.removeOverlays(map.overlays)
        map.deselectAnnotation(map.selectedAnnotations[0], animated: true)
        userImage = nil
        guard let startUpViewController = currentViewController.storyboard?.instantiateViewController(withIdentifier: "StartUpScreenViewController") else {return}
        currentViewController.navigationController?.pushViewController(startUpViewController, animated: true)
    //Why is default never executed?
    default:
        break
    }
}

func slideOutSidebar(_ currentViewController: UIViewController){
    guard let sidebarMenuViewController = currentViewController.storyboard?.instantiateViewController(withIdentifier: "SidebarMenuViewController") as? SidebarMenuViewController else {return}
    sidebarMenuViewController.didTapMenuType = {menuType in
        transitiontoNewVC(menuType, currentViewController: currentViewController)
    }
    sidebarMenuViewController.modalPresentationStyle = .overCurrentContext
    sidebarMenuViewController.transitioningDelegate = universe
    currentViewController.present(sidebarMenuViewController, animated: true)
    //Yo idk if you fellas want this but at least while the
    //Event manager is empty it looks bad with both up cuz the
    //Map gets blocked so...
    if let mapViewController = currentViewController as? MapViewController{
        mapViewController.eventManagerSlideUpView.popUpViewToBottom()
    }
    
}

class Universal: NSObject, UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

