//
//  Event.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 3/23/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import Foundation
import MapKit
import FirebaseAuth
class Event: NSObject, MKAnnotation{

    
    var coordinate: CLLocationCoordinate2D
    var title : String?
    var owner : String
    var joined : [String]
    var time : Date
    var subtitle: String?
    
    override convenience init(){
        self.init(title: String(), owner: String(), coordinate: CLLocationCoordinate2D(), time: Date(), description: String(), joined: [])
    }
    convenience init(coordinate: CLLocationCoordinate2D){
        self.init(title: String(), owner: String(), coordinate: coordinate, time: Date(), description: String(), joined: [])
    }
    init(title: String, owner: String, coordinate: CLLocationCoordinate2D, time: Date, description: String){
        self.title = title
        self.owner = owner
        self.coordinate = coordinate
        self.time = time
        self.joined = []
        self.subtitle = description
    }
    init(title: String, owner: String, coordinate: CLLocationCoordinate2D, time: Date, description: String, joined: [String]){
        self.title = title
        self.owner = owner
        self.coordinate = coordinate
        self.time = time
        self.joined = joined
        self.subtitle = description
    }
    
    func getTitle() -> String?{
        return title
    }
    func getOwner() -> String{
        return owner
    }
    func getCoordinate() -> CLLocationCoordinate2D{
        return coordinate
    }
    func getTime() -> Date{
        return time
    }
    func getJoined() -> [String]{
        return joined
    }
    func getSubtitle() -> String?{
        return subtitle
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let event = object as? Event else {return false}
        if self.coordinate.longitude == event.coordinate.longitude &&
        self.coordinate.latitude == event.coordinate.latitude &&
        self.title == event.title &&
        self.owner == event.owner &&
        self.time == event.time &&
        self.joined == event.joined &&
        self.subtitle == event.subtitle{
            return true
        }
        return false
    }
}
