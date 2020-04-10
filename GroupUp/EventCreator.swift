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

class EventCreator: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    let cellID = "cell"
    var locationString = NSAttributedString(string: "Set Location")
    var reloadData = false
    var openDatePicker = false
    var openActivityPicker = false
    let dateFormatter = DateFormatter()
    let nameTextField = UITextField(frame: CGRect(x: 20, y: 0, width: 410, height: 50))
    let descriptionTextField = UITextField(frame: CGRect(x: 20, y: 0, width: 410, height: 50))
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (openDatePicker && section == 2) || (openActivityPicker && section == 3) ? 2 : tableViewArray[section].count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            //Heyyyy don't forget to reset this at some point!!!
                navigationController?.pushViewController(eventLocationCreator, animated: true)
        }
        else if indexPath.section == 2 && indexPath.row == 0{
            let datePickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            dateChanged(picker: eventDateField)

            openDatePicker = !openDatePicker
            if openDatePicker{
                tableView.insertRows(at: [datePickerIndexPath], with: .automatic)
            }
            else{
                tableView.deleteRows(at: [datePickerIndexPath], with: .automatic)

            }
            
        }
        else if indexPath.section == 3 && indexPath.row == 0{
            let activityPickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            openActivityPicker = !openActivityPicker
            if openActivityPicker{
                tableView.insertRows(at: [activityPickerIndexPath], with: .automatic)
            }
            else{
                tableView.deleteRows(at: [activityPickerIndexPath], with: .automatic)
            }
        }
        if let deselectRow = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: deselectRow, animated: true)
        }
    }
    @objc func activateNameField(){
        nameTextField.becomeFirstResponder()
    }
    @objc func activateDescriptionField(){
        descriptionTextField.becomeFirstResponder()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.section == 0 && indexPath.row == 0{
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
            button.addTarget(self, action: #selector(activateNameField), for: .touchUpInside)
            button.backgroundColor = .systemGray6
            cell.backgroundColor = .systemGray6
            nameTextField.attributedPlaceholder = NSAttributedString(string:tableViewArray[indexPath.section][indexPath.row].string, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray2])
            
            cell.addSubview(nameTextField)
            cell.addSubview(button)
            return cell
        }
        else if indexPath.section == 0 && indexPath.row == 1{
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
            button.addTarget(self, action: #selector(activateDescriptionField), for: .touchUpInside)
            button.backgroundColor = .systemGray6
            cell.backgroundColor = .systemGray6
            descriptionTextField.attributedPlaceholder = NSAttributedString(string:tableViewArray[indexPath.section][indexPath.row].string, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray2])
                       
            cell.addSubview(descriptionTextField)
            cell.addSubview(button)
            return cell
        }
        else if indexPath.section == 2 && indexPath.row == 1{
            cell.backgroundColor = .systemGray5
            cell.addSubview(eventDateField)
            return cell
            
        }
        else if indexPath.section == 3 && indexPath.row == 1{
            
            cell.backgroundColor = .systemGray5
            cell.addSubview(activityField)
            
            return cell
        }
        if(indexPath.section == 2 && indexPath.row == 1){
            print("We in it")
        }
        cell.backgroundColor = .systemGray6
        cell.textLabel?.attributedText = tableViewArray[indexPath.section][indexPath.row]
        return cell
        
        
        
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (openDatePicker && indexPath.section == 2 || openActivityPicker && indexPath.section == 3) && indexPath.row == 1 ? 180 : 50
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .black
        return headerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if reloadData{
            tableViewArray[1][0] = locationString
            tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .left)
            reloadData = false
        }
    }
    
    
    
    
    let label = UILabel()
    let eventName = UILabel()
    let eventLocation = UILabel()
    let eventDate = UILabel()
    let eventDescription = UILabel()
    let eventType = UILabel()
    var types = ["basketball", "soccer", "lacrosse", "badmitten"]
    let setLocationButton = UIButton()
    
    var tableViewArray = [
        [NSAttributedString(string: "Name"), NSAttributedString(string: "Description")],
    [NSAttributedString(string: "Set Location")],
    [NSAttributedString(string: "Set Date")],
    [NSAttributedString(string: "Set Activity")],
    [NSAttributedString(string: "Set Permissions")]
    ]
    let activityField = UIPickerView()
    
    let createEventButton = UIButton()
    
    let eventNameField = UITextField(frame: CGRect(x: 20, y: 160, width: 300, height: 25))
    let eventLocationField = UITextField(frame: CGRect(x: 20, y: 360, width: 300, height: 25))
    let eventDescriptionField = UITextField(frame: CGRect(x: 20, y: 260, width: 300, height: 25))
    let eventDateField =  UIDatePicker()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dateChanged(picker: UIDatePicker){
        let date = picker.date
        let displayDate = dateFormatter.string(from: date)
        tableViewArray[2][0] = NSAttributedString(string: displayDate, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemBlue])

        tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
        
    }
    func setUpTextFields(){
        
        nameTextField.returnKeyType = .next
        nameTextField.backgroundColor = .systemGray6
        nameTextField.delegate = self
        
        
        descriptionTextField.returnKeyType = .next
        descriptionTextField.backgroundColor = .systemGray6
        descriptionTextField.delegate = self
    }
    override func viewDidLoad() {
        view.backgroundColor = UIColor.black
        eventDateField.frame = CGRect(x: 0, y: 0, width: 380, height: 180)
        eventDateField.minuteInterval = 5
        eventDateField.addTarget(self, action: #selector(dateChanged(picker:)), for: .valueChanged)
        activityField.delegate = self
        activityField.dataSource = self
        activityField.frame = CGRect(x: 0, y: 0, width: 380, height: 180)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        //tableView.isScrollEnabled = false
        tableView.separatorColor = .systemGray5
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "EEEE MMMM dd, yyyy    h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        setUpTextFields()
//        eventName.text = "Event Name"
//        eventLocation.text = "Event Location"
//        eventDate.text = "Event Date"
//        eventDescription.text = "Event Description"
//        label.text = "New Event"
//        eventType.text =  "Event Type"
//
//        setLocationButton.setTitle("Set Location", for: .normal)
//        setLocationButton.setTitleColor(.systemPink, for: .normal)
//        setLocationButton.backgroundColor = .darkGray
//        setLocationButton.addTarget(self, action: #selector(setLocation), for: .touchUpInside)
//        //setLocationButton.backgroundColor = .systemPink
//        setLocationButton.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(setLocationButton)
//
//
//        setLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 160).isActive = true
//        setLocationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -300).isActive = true
//        setLocationButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        setLocationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//
//        eventNameField.delegate = self
//        eventLocationField.delegate = self
//        eventDescriptionField.delegate = self
//
//        label.textColor = UIColor.white
//
//        eventName.textColor = UIColor.white
//        eventLocation.textColor = UIColor.white
//        eventDate.textColor = UIColor.white
//        eventDescription.textColor = .white
//        eventType.textColor = .white
//
//        label.frame = CGRect(x: 30, y: 80, width: 250, height: 30)
//        eventName.frame = CGRect(x: 30, y: 130, width: 250, height: 30)
//        eventDescription.frame = CGRect(x: 30, y: 230, width: 250, height: 30)
//        eventLocation.frame = CGRect(x: 30, y: 330, width: 250, height: 30)
//        eventDate.frame = CGRect(x: 30, y: 430, width: 250, height: 30)
//        eventType.frame = CGRect(x: 30, y: 530, width: 250, height: 30)
//
//
//        label.font = UIFont(name: "Arial", size: 20)
//        eventName.font = UIFont(name: "Arial", size: 20)
//        eventLocation.font = UIFont(name: "Arial", size: 20)
//        eventDate.font = UIFont(name: "Arial", size: 20)
//        eventDescription.font = UIFont(name: "Arial", size: 20)
//        eventType.font = UIFont(name: "Arial", size: 20)
//
//        self.view.addSubview(label)
//
//        createEventButton.frame = CGRect(x: 150, y: 750, width: 120, height: 50)
//        createEventButton.setTitle("Create Event", for: .normal)
//        createEventButton.backgroundColor = .blue
//        createEventButton.layer.cornerRadius = 8.0
//        createEventButton.clipsToBounds = true
//        createEventButton.addTarget(self, action: #selector(createEvent), for: .touchUpInside)
//
//        eventNameField.backgroundColor = .white
//        eventLocationField.backgroundColor = .white
//        eventDescriptionField.backgroundColor = .white
//        //eventTypeField.delegate = self
//        //eventTypeField.backgroundColor = .white
//
//        eventNameField.textColor = .black
//        eventLocationField.textColor = .black
//        eventDescriptionField.textColor = .black
//
//
//        eventDateField.frame = CGRect(x: 50, y: 440, width: 300, height: 200)
//
//        self.view.addSubview(eventDateField)
//        self.view.addSubview(eventLocationField)
//        self.view.addSubview(eventNameField)
//        self.view.addSubview(createEventButton)
//        self.view.addSubview(eventName)
//        self.view.addSubview(eventLocation)
//        self.view.addSubview(eventDate)
//        self.view.addSubview(eventDescription)
//        self.view.addSubview(eventDescriptionField)
//        self.view.addSubview(eventType)
//        //self.view.addSubview(eventTypeField)
//        self.view.addSubview(setLocationButton)
//
        

        
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
    
    
    @objc func setLocation(){
        if let indexPath = tableView.indexPathForSelectedRow{
            print("Index path is: \(indexPath)")
        }
        else{
            print("What the hell")
        }
        //tableView.deselectRow(at: , animated: true)
        let setLocationVC = EventLocationCreatorViewController()
        navigationController?.pushViewController(setLocationVC, animated: true)
        
    }
    @objc func createEvent(){
        guard let name = eventNameField.text else {return}
        guard let owner = Auth.auth().currentUser else {return}
        guard let description = eventDescriptionField.text else {return}
        //Fix location
        let time = eventDateField.date
        //"latitude" : "40.0102", "longitude" : "-75.2797"
        //"latitude" : "40.0423", "longitude" : "-75.3167"
        //let event = Event(title: name, owner: owner.uid, coordinate: CLLocationCoordinate2D(latitude: 40.0423, longitude: -75.3167), time: time)
        var eventDictionary = ["owner" : owner.uid, "joined" : [owner.uid], "time" : "\(time.timeIntervalSinceReferenceDate)",
            "title" : name, "latitude" : "\(location.latitude)", "longitude" : "\(location.longitude)" , "description" : description] as [String : Any]
        
        databaseRef.child("events/").updateChildValues(["\(events.count)":eventDictionary])

        eventDictionary["owner"] = nil
        databaseRef.child("users/\(owner.uid)").updateChildValues(["created" : ["\(events.count)" : eventDictionary]])
       // databaseRef.child("users/\(owner)/created").updateChildValues([eventDictionary])
        navigationController?.popToRootViewController(animated: true)
    }
}
