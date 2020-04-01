//
//  EventCreator.swift
//  GroupUp
//
//  Created by Seth Richards (student LM) on 3/4/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import MapKit
class EventCreator: UIViewController, UITextFieldDelegate{
    let label = UILabel()
    let eventName = UILabel()
    let eventLocation = UILabel()
    let eventDate = UILabel()
    let eventDescription = UILabel()
    let eventType = UILabel()
    var types = [String]()
    
    let eventTypeField = UIPickerView()
    
    let createEventButton = UIButton()
    
    let eventNameField = UITextField(frame: CGRect(x: 20, y: 160, width: 300, height: 25))
    let eventLocationField = UITextField(frame: CGRect(x: 20, y: 360, width: 300, height: 25))
    let eventDescriptionField = UITextField(frame: CGRect(x: 20, y: 260, width: 300, height: 25))
    let eventDateField =  UIDatePicker()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.black
        
        eventName.text = "Event Name"
        eventLocation.text = "Event Location"
        eventDate.text = "Event Date"
        eventDescription.text = "Event Description"
        label.text = "New Event"
        eventType.text =  "Event Type"
        
        eventNameField.delegate = self
        eventLocationField.delegate = self
        eventDescriptionField.delegate = self
        
        label.textColor = UIColor.white
        
        eventName.textColor = UIColor.white
        eventLocation.textColor = UIColor.white
        eventDate.textColor = UIColor.white
        eventDescription.textColor = .white
        eventType.textColor = .white
        
        label.frame = CGRect(x: 30, y: 80, width: 250, height: 30)
        eventName.frame = CGRect(x: 30, y: 130, width: 250, height: 30)
        eventDescription.frame = CGRect(x: 30, y: 230, width: 250, height: 30)
        eventLocation.frame = CGRect(x: 30, y: 330, width: 250, height: 30)
        eventDate.frame = CGRect(x: 30, y: 430, width: 250, height: 30)
        eventType.frame = CGRect(x: 30, y: 530, width: 250, height: 30)

        
        label.font = UIFont(name: "Arial", size: 20)
        eventName.font = UIFont(name: "Arial", size: 20)
        eventLocation.font = UIFont(name: "Arial", size: 20)
        eventDate.font = UIFont(name: "Arial", size: 20)
        eventDescription.font = UIFont(name: "Arial", size: 20)
        eventType.font = UIFont(name: "Arial", size: 20)
        
        self.view.addSubview(label)
        
        createEventButton.frame = CGRect(x: 150, y: 750, width: 120, height: 50)
        createEventButton.setTitle("Create Event", for: .normal)
        createEventButton.backgroundColor = .blue
        createEventButton.layer.cornerRadius = 8.0
        createEventButton.clipsToBounds = true
        createEventButton.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
        
        eventNameField.backgroundColor = .white
        eventLocationField.backgroundColor = .white
        eventDescriptionField.backgroundColor = .white
        eventTypeField.backgroundColor = .white
        
        eventNameField.textColor = .black
        eventLocationField.textColor = .black
        eventDescriptionField.textColor = .black

        
        eventDateField.frame = CGRect(x: 50, y: 440, width: 300, height: 200)
        
        self.view.addSubview(eventDateField)
        self.view.addSubview(eventLocationField)
        self.view.addSubview(eventNameField)
        self.view.addSubview(createEventButton)
        self.view.addSubview(eventName)
        self.view.addSubview(eventLocation)
        self.view.addSubview(eventDate)
        self.view.addSubview(eventDescription)
        self.view.addSubview(eventDescriptionField)
        self.view.addSubview(eventType)
        self.view.addSubview(eventTypeField)
        
        types.append("Sports")
        types.append("Homework")
        types.append("Clubs")
        types.append("Activities")
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
          return types.count
       }
       
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           let defaults = UserDefaults.standard
           defaults.set(row, forKey: "row")
    }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return "\(types[row])"
    }
    
    @objc func createEvent(){
        guard let name = eventNameField.text else {return}
        guard let owner = Auth.auth().currentUser else {return}
        guard let description = eventDescriptionField.text else {return}
        //Fix location
        guard let location = eventLocationField.text else {return}
        let time = eventDateField.date
        //"latitude" : "40.0102", "longitude" : "-75.2797"
        //"latitude" : "40.0423", "longitude" : "-75.3167"
        //let event = Event(title: name, owner: owner.uid, coordinate: CLLocationCoordinate2D(latitude: 40.0423, longitude: -75.3167), time: time)
        var eventDictionary = ["owner" : owner.uid, "joined" : [owner.uid], "time" : "\(time.timeIntervalSinceReferenceDate)",
            "title" : name, "latitude" : "40.0102", "longitude" : "-75.2797" , "description" : description] as [String : Any]
        
        databaseRef.child("events/").updateChildValues(["\(events.count)":eventDictionary])

        eventDictionary["owner"] = nil
        databaseRef.child("users/\(owner.uid)").updateChildValues(["created" : ["\(events.count)" : eventDictionary]])
       // databaseRef.child("users/\(owner)/created").updateChildValues([eventDictionary])
        navigationController?.popToRootViewController(animated: true)
    }
}
