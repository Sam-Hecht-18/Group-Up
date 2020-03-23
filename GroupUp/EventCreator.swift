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
    let eventDescription = UILabel()
    
    let createEvent = UIButton()
    
    let eventNameField = UITextField(frame: CGRect(x: 20, y: 160, width: 300, height: 25))
    let eventLocationField = UITextField(frame: CGRect(x: 20, y: 360, width: 300, height: 25))
    let eventDescriptionField = UITextField(frame: CGRect(x: 20, y: 260, width: 300, height: 25))
    let eventDateField =  UIDatePicker()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.black
        
        eventName.text = "Event Name"
        eventLocation.text = "Event Location"
        eventDate.text = "Event Date"
        eventDescription.text = "Event Description"
        label.text = "New Event"
        
        label.textColor = UIColor.white
        
        eventName.textColor = UIColor.white
        eventLocation.textColor = UIColor.white
        eventDate.textColor = UIColor.white
        eventDescription.textColor = .white
        
        label.frame = CGRect(x: 30, y: 80, width: 250, height: 30)
        eventName.frame = CGRect(x: 30, y: 130, width: 250, height: 30)
        eventDescription.frame = CGRect(x: 30, y: 230, width: 250, height: 30)
        eventLocation.frame = CGRect(x: 30, y: 330, width: 250, height: 30)
        eventDate.frame = CGRect(x: 30, y: 430, width: 250, height: 30)

        
        label.font = UIFont(name: "Arial", size: 20)
        eventName.font = UIFont(name: "Arial", size: 20)
        eventLocation.font = UIFont(name: "Arial", size: 20)
        eventDate.font = UIFont(name: "Arial", size: 20)
        eventDescription.font = UIFont(name: "Arial", size: 20)
        
        self.view.addSubview(label)
        
        createEvent.frame = CGRect(x: 150, y: 750, width: 120, height: 50)
        createEvent.setTitle("Create Event", for: .normal)
        createEvent.backgroundColor = .blue
        createEvent.layer.cornerRadius = 8.0
        createEvent.clipsToBounds = true
        
        
        eventNameField.backgroundColor = .white
        eventLocationField.backgroundColor = .white
        eventDescriptionField.backgroundColor = .white

        
        eventDateField.frame = CGRect(x: 50, y: 440, width: 300, height: 200)
        
        self.view.addSubview(eventDateField)
        self.view.addSubview(eventLocationField)
        self.view.addSubview(eventNameField)
        self.view.addSubview(createEvent)
        self.view.addSubview(eventName)
        self.view.addSubview(eventLocation)
        self.view.addSubview(eventDate)
        self.view.addSubview(eventDescription)
        self.view.addSubview(eventDescriptionField)
        
    }
    
     @objc func buttonClicked(_ : UIButton){
           let eventViewController = EventCreator()
           navigationController?.pushViewController(eventViewController, animated: true)
           //self.present(eventViewController, animated: true, completion: nil)
       }
    
}
