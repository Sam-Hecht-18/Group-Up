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
    override convenience init(){
        self.init(title: String(), owner: String(), coordinate: CLLocationCoordinate2D(), time: Date(), joined: [])
    }
    init(title: String, owner: String, coordinate: CLLocationCoordinate2D, time: Date){
        self.title = title
        self.owner = owner
        self.coordinate = coordinate
        self.time = time
        self.joined = []
    }
    init(title: String, owner: String, coordinate: CLLocationCoordinate2D, time: Date, joined: [String]){
        self.title = title
        self.owner = owner
        self.coordinate = coordinate
        self.time = time
        self.joined = joined
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
    override func isEqual(_ object: Any?) -> Bool {
        guard let event = object as? Event else {return false}
        if self.coordinate.longitude == event.coordinate.longitude &&
        self.coordinate.latitude == event.coordinate.latitude &&
        self.title == event.title &&
        self.owner == event.owner &&
        self.time == event.time &&
        self.joined == event.joined{
            return true
        }
        return false
    }
}
