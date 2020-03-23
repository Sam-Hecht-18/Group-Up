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
class Event{
    private var name : String
    private var owner : User
    private var joined : [User]
    private var location : CLLocationCoordinate2D
    private var time : Date
    
    init(name: String, owner: User, location: CLLocationCoordinate2D, time: Date){
        self.name = name
        self.owner = owner
        self.location = location
        self.time = time
        self.joined = []
    }
    
    func getName() -> String{
        return name
    }
    func getOwner() -> User{
        return owner
    }
    func getLocation() -> CLLocationCoordinate2D{
        return location
    }
    func getTime() -> Date{
        return time
    }
    func getJoined() -> [User]{
        return joined
    }
}
