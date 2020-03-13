//
//  EventCreator.swift
//  GroupUp
//
//  Created by Seth Richards (student LM) on 3/4/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit

class EventCreator: UIViewController{
      let label = UILabel()
        let eventName = UILabel()
        let eventLocation = UILabel()
        let eventDate = UILabel()

        
        let createEvent = UIButton()
        
        let eventNameField = UITextField(frame: CGRect(x: 20, y: 150, width: 300, height: 25))
        let eventLocationField = UITextField(frame: CGRect(x: 20, y: 250, width: 300, height: 25))
        let eventDateField =  UIDatePicker()
        
        override func viewDidLoad() {
            view.backgroundColor = UIColor.black

            eventName.text = "Event Name"
            eventLocation.text = "Event Location"
            eventDate.text = "Event Date"
            label.text = "New Event"

            label.textColor = UIColor.white

            eventName.textColor = UIColor.white
            eventLocation.textColor = UIColor.white
            eventDate.textColor = UIColor.white
            
            label.frame = CGRect(x: 30, y: 80, width: 250, height: 30)
            eventName.frame = CGRect(x: 30, y: 130, width: 250, height: 30)
            eventLocation.frame = CGRect(x: 30, y: 180, width: 250, height: 30)
            eventDate.frame = CGRect(x: 30, y: 230, width: 250, height: 30)

           // label.font = UIFont.boldSystemFont(ofSize: 46.0)
            label.font = UIFont(name: "Arial", size: 35)

            self.view.addSubview(label)
            
            createEvent.frame = CGRect(x: 275, y: 600, width: 120, height: 100)
            createEvent.setTitle("Create Event", for: .normal)
            createEvent.backgroundColor = .black
        
            eventNameField.backgroundColor = .white
            eventDateField.backgroundColor = .white
            eventLocationField.backgroundColor = .white
            
            
            //self.view.addSubview(eventDateField)
            self.view.addSubview(eventLocationField)
            self.view.addSubview(eventNameField)
            self.view.addSubview(createEvent)
            self.view.addSubview(eventName)
            self.view.addSubview(eventLocation)
            self.view.addSubview(eventDate)
            
        
        
    }
}
