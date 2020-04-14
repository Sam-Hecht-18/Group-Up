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
    var locationString = NSAttributedString(string: "Set Location")
    var openDatePicker = false
    var openActivityPicker = false
    var openPermissionControl = false
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "EEEE MMMM dd, yyyy    h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    
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
    
    
    let activityPickerView = UIPickerView()
    let datePickerView =  UIDatePicker()
      
    var types = ["Basketball", "Soccer", "Lacrosse", "Badminton"]
       
       
    var tableViewArray = [
        [NSAttributedString(string: "Name"), NSAttributedString(string: "Description")],
        [NSAttributedString(string: "Set Location")],
        [NSAttributedString(string: "Set Date")],
        [NSAttributedString(string: "Set Activity")],
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
        
        activityPickerView.delegate = self
        activityPickerView.dataSource = self
        activityPickerView.frame = CGRect(x: 0, y: 0, width: 380, height: 180)
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
        
        return (openDatePicker && section == 2) || (openActivityPicker && section == 3) || (openPermissionControl && section == 4) ? 2 : tableViewArray[section].count
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
            let activityPickerIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            pickerView(activityPickerView, didSelectRow: 0, inComponent: 0)
            openActivityPicker = !openActivityPicker
            collapseExpand(boolean: openActivityPicker, indexPath: activityPickerIndexPath)
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
            cell.addSubview(activityPickerView)
            
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
        return (openDatePicker && indexPath.section == 2 || openActivityPicker && indexPath.section == 3) && indexPath.row == 1 ? 180 : 50
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
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tableViewArray[3][0] = NSAttributedString(string: types[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemBlue])
        tableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: .automatic)
        allowEventCreation[3] = true
        checkEventCreationStatus()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //If you want to change the colors or add a picutre instead do the attributed title for row method
        return "\(types[row])"
    }
    
    @objc func activateNameField(){
        nameTextField.becomeFirstResponder()
    }
    @objc func activateDescriptionField(){
        descriptionTextField.becomeFirstResponder()
    }
    
    @objc func dateChanged(picker: UIDatePicker){
        let date = picker.date
        let displayDate = dateFormatter.string(from: date)
        tableViewArray[2][0] = NSAttributedString(string: displayDate, attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemBlue])
        
        tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
        allowEventCreation[2] = true
        checkEventCreationStatus()
    }
    
    @objc func permissionsChanged(_ segmentedControl: UISegmentedControl){
        tableViewArray[4][0] = NSAttributedString(string: "Visible to: \(permissionPossibilities[segmentedControl.selectedSegmentIndex])", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemBlue])
        tableView.reloadRows(at: [IndexPath(row: 0, section: 4)], with: .automatic)
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
        
        
        guard let name = nameTextField.text else {return}
        guard let owner = Auth.auth().currentUser else {return}
        var description = ""
        if let desc = descriptionTextField.text{
            description = desc
        }
        
        //Fix location
        let time = datePickerView.date
        let activity = types[activityPickerView.selectedRow(inComponent: 0)]
        
        var eventDictionary = ["owner" : owner.uid, "joined" : [owner.uid], "time" : "\(time.timeIntervalSinceReferenceDate)",
            "title" : name, "latitude" : "\(eventLocation.latitude)", "longitude" : "\(eventLocation.longitude)" , "description" : description, "activity" : activity] as [String : Any]
        guard let identifier = databaseRef.child("events/").childByAutoId().key else {return}
        databaseRef.child("events/\(identifier)").updateChildValues(eventDictionary)
        
        eventDictionary["owner"] = nil
        databaseRef.child("users/\(owner.uid)/created/\(identifier)").updateChildValues(eventDictionary)
        
        eventLocationCreator = EventLocationCreatorViewController()
        navigationController?.popToRootViewController(animated: true)
    }
}
