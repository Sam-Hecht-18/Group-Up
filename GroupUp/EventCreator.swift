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


class EventCreator: UITableViewController, UITextFieldDelegate{
    var locationString = NSAttributedString(string: "Set Location")
    var openDatePicker = false
    var openActivityControl = false
    var openPermissionControl = false
    
    
    
    let nameTextField = UITextField(frame: CGRect(x: 20, y: 0, width: 410, height: 50))
    let descriptionTextField = UITextField(frame: CGRect(x: 20, y: 0, width: 410, height: 50))
    
    let permissionPossibilities = ["Friends", "Classmates", "Anyone"]
    lazy var permissionControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: permissionPossibilities)
        segmentedControl.frame = CGRect(x: 1, y: 0, width: 410, height: 50)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(permissionsChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    let activityPossibilities = ["Athletic", "Scholarly", "Misc."]
    lazy var activityControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: activityPossibilities)
        segmentedControl.frame = CGRect(x: 1, y: 0, width: 410, height: 50)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(activityChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    let datePickerView =  UIDatePicker()
      
    //var types = ["Basketball", "Soccer", "Lacrosse", "Badminton"]
       
       
    var tableViewArray = [
        [NSAttributedString(string: "Name"), NSAttributedString(string: "Description")],
        [NSAttributedString(string: "Set Location")],
        [NSAttributedString(string: "Set Date")],
        [NSAttributedString(string: "Set Type of Activity")],
        [NSAttributedString(string: "Set Permissions")]
    ]
    
    var eventLocation = CLLocationCoordinate2D()
    
    var allowEventCreation = [false, false, false, false, false]
    override func viewDidLoad() {
        view.backgroundColor = UIColor.black
        setUpTableView()
        setUpPickerViews()
        setUpTextFields()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create Event", style: .plain, target: self, action: #selector(createEvent))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func setUpTableView(){
        tableView = UITableView(frame: tableView.frame, style: .grouped)
        tableView.separatorColor = .systemGray5
    }
    
    func setUpPickerViews(){
        datePickerView.frame = CGRect(x: 0, y: 0, width: 380, height: 180)
        datePickerView.minuteInterval = 5
        datePickerView.addTarget(self, action: #selector(dateChanged(picker:)), for: .valueChanged)
        
        
    }
    
    func setUpTextFields(){
        
        nameTextField.returnKeyType = .next
        nameTextField.backgroundColor = .systemGray6
        nameTextField.delegate = self
        
        
        descriptionTextField.returnKeyType = .next
        descriptionTextField.backgroundColor = .systemGray6
        descriptionTextField.delegate = self
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if nameTextField.isEqual(textField) && nameTextField.text != nil{
            allowEventCreation[0] = true
            checkEventCreationStatus()
        }
        else if nameTextField.isEqual(textField) && nameTextField.text == nil{
            allowEventCreation[0] = false
            checkEventCreationStatus()
        }
        
    }
    func collapseExpand(boolean: Bool, indexPath: IndexPath){
        if boolean{
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        else{
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (openDatePicker && section == 2) || (openActivityControl && section == 3) || (openPermissionControl && section == 4) ? 2 : tableViewArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if nameTextField.isFirstResponder{
            nameTextField.resignFirstResponder()
        }
        else if descriptionTextField.isFirstResponder{
            descriptionTextField.resignFirstResponder()
        }
        if indexPath.section == 1 {
            //Heyyyy don't forget to reset this at some point!!!
            navigationController?.pushViewController(eventLocationCreator, animated: true)
        }
        else if indexPath.section == 2 && indexPath.row == 0{
            let datePickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            dateChanged(picker: datePickerView)
            openDatePicker = !openDatePicker
            collapseExpand(boolean: openDatePicker, indexPath: datePickerIndexPath)
            
        }
        else if indexPath.section == 3 && indexPath.row == 0{
            let activityControlIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            activityChanged(activityControl)
            //let selectedRow = activityPickerView.selectedRow(inComponent: 0)
            //pickerView(activityPickerView, didSelectRow: selectedRow, inComponent: 0)
            openActivityControl = !openActivityControl
            collapseExpand(boolean: openActivityControl, indexPath: activityControlIndexPath)
            allowEventCreation[3] = true
        }
        else if indexPath.section == 4 && indexPath.row == 0{
            let permissionControlIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            permissionsChanged(permissionControl)
            openPermissionControl = !openPermissionControl
            collapseExpand(boolean: openPermissionControl, indexPath: permissionControlIndexPath)
            allowEventCreation[4] = true
            checkEventCreationStatus()
        }
        if let deselectRow = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: deselectRow, animated: true)
        }
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
            cell.addSubview(datePickerView)
            return cell
            
        }
        else if indexPath.section == 3 && indexPath.row == 1{
            
            cell.backgroundColor = .systemGray5
            cell.addSubview(activityControl)
            
            return cell
        }
        else if indexPath.section == 4 && indexPath.row == 1{
            cell.backgroundColor = .systemGray5
            cell.addSubview(permissionControl)
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
        return (openDatePicker && indexPath.section == 2) && indexPath.row == 1 ? 180 : 50
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .black
        return headerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(row: 0, section: 1)
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        
        if cell.textLabel?.attributedText != locationString {
            tableViewArray[1][0] = locationString
            tableView.reloadRows(at: [indexPath], with: .left)
            allowEventCreation[1] = true
            checkEventCreationStatus()
        }
        
    }
    
    
    
    
   
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @objc func activateNameField(){
        nameTextField.becomeFirstResponder()
    }
    @objc func activateDescriptionField(){
        descriptionTextField.becomeFirstResponder()
    }
    
    @objc func dateChanged(picker: UIDatePicker){
        let date = picker.date
        
        if date.timeIntervalSinceReferenceDate < Date(timeIntervalSinceNow: 0).timeIntervalSinceReferenceDate{
             tableViewArray[2][0] = NSAttributedString(string: "Invalid Date", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemRed])
            tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)

            allowEventCreation[2] = false
        }
        else{
            let displayDate = dateFormatter.string(from: date)
            tableViewArray[2][0] = NSAttributedString(string: displayDate, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemBlue])
        
            tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
            allowEventCreation[2] = true
        }
        checkEventCreationStatus()
    }
    
    @objc func permissionsChanged(_ segmentedControl: UISegmentedControl){
        tableViewArray[4][0] = NSAttributedString(string: "Visible to: \(permissionPossibilities[segmentedControl.selectedSegmentIndex])", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemBlue])
        tableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: .automatic)
    }
    @objc func activityChanged(_ segmentedControl: UISegmentedControl){
        tableViewArray[3][0] = NSAttributedString(string: " \(activityPossibilities[segmentedControl.selectedSegmentIndex])", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemBlue])
        tableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .automatic)
    }
    func checkEventCreationStatus(){
        for boolean in allowEventCreation{
            if !boolean{
                return
            }
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    @objc func createEvent(){
        eventLocationCreator = EventLocationCreatorViewController()

        guard let name = nameTextField.text else {return}
        guard let owner = Auth.auth().currentUser else {return}
        var description = ""
        if let desc = descriptionTextField.text{
            description = desc
        }
        
        //Fix location
        let time = datePickerView.date
        let activity = activityPossibilities[activityControl.selectedSegmentIndex]
        let permission = permissionPossibilities[permissionControl.selectedSegmentIndex]
        
        let eventDictionary = [
            "owner" : owner.uid,
            "joined" : [owner.uid],
            "time" : "\(time.timeIntervalSinceReferenceDate)",
            "title" : name,
            "latitude" : "\(eventLocation.latitude)",
            "longitude" : "\(eventLocation.longitude)" ,
            "description" : description,
            "activity" : activity,
            "permissions" : permission
            ] as [String : Any]
            
        guard let identifier = databaseRef.child("events/").childByAutoId().key else {return}
        databaseRef.child("events/\(identifier)").updateChildValues(eventDictionary)
        
        databaseRef.child("users/\(owner.uid)/created").observeSingleEvent(of: .value) { (snapshot) in
            print("Ok crating is a thing without the thing")
            guard var created = snapshot.value as? [String] else {
                databaseRef.child("users/\(owner.uid)").updateChildValues(["created" : [identifier]])
                return}
            created.append(identifier)
            databaseRef.child("users/\(owner.uid)").updateChildValues(["created" : created])
        }
        
        
        
        navigationController?.popToRootViewController(animated: true)
    }
}
