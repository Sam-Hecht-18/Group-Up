//
//  ProfileViewController.swift
//  GroupUp
//
//  Created by Eli Forman (student LM) on 3/4/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import MapKit
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    var myEvents = [[Event](), [Event]()]
    var createdTableView = UITableView()
    var joinedTableView = UITableView()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return myEvents[tableView.tag].count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = createdTableView.dequeueReusableCell(withIdentifier: "event") else {return UITableViewCell()}
        cell.textLabel?.numberOfLines = 10
        cell.textLabel?.textAlignment = .center
        let cellText = NSMutableAttributedString()
        cellText.append(NSAttributedString(string: "\(myEvents[tableView.tag][indexPath.section].title!)\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 43/255.0, green: 183/255.0, blue: 183/255.0, alpha: 1.0), NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 30)!]))
        
        cellText.append(NSAttributedString(string: myEvents[tableView.tag][indexPath.section].subtitle!, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 43/255.0, green: 183/255.0, blue: 183/255.0, alpha: 1.0), NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 26)!]))
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        cell.textLabel?.attributedText = cellText
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        cell.layer.borderWidth = 3
        cell.backgroundColor = .systemGray3
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 1)
        let view = UIView(frame: frame)
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("I am occurring indeed samuel")
        let selectedEvent = myEvents[tableView.tag][indexPath.section]
        
        transitiontoNewVC(.map, currentViewController: self)
        map.selectAnnotation(selectedEvent, animated: false)
        print("I finished occurring indeed samuel")
        
    }
    
    
    
    func setUpJoinedTableView(){
        joinedTableView.register(UITableViewCell.self, forCellReuseIdentifier: "event")
        joinedTableView.tag = 1
        joinedTableView.delegate = self
        joinedTableView.dataSource = self
        joinedTableView.separatorColor = .clear
        joinedTableView.backgroundColor = UIColor.systemGray5
        joinedTableView.layer.cornerRadius = 10
        joinedTableView.layer.borderColor = UIColor.systemGray3.cgColor
        joinedTableView.layer.borderWidth = 3
        
        joinedTableView.isHidden = true
        joinedTableView.allowsSelection = false
        joinedTableView.isScrollEnabled = false
        
        view.addSubview(joinedTableView)
        joinedTableView.translatesAutoresizingMaskIntoConstraints = false
        joinedTableView.topAnchor.constraint(equalTo: joinedEventsButton.bottomAnchor, constant: 10).isActive = true
        joinedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        joinedTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100).isActive = true
        joinedTableView.widthAnchor.constraint(equalToConstant: view.frame.width/2-10).isActive = true
        
    }
    func setUpCreatedTableView(){
        createdTableView.register(UITableViewCell.self, forCellReuseIdentifier: "event")
        createdTableView.tag = 0
        createdTableView.delegate = self
        createdTableView.dataSource = self
        createdTableView.separatorColor = .clear
        createdTableView.backgroundColor = UIColor.systemGray5
        createdTableView.layer.cornerRadius = 10
        createdTableView.layer.borderColor = UIColor.systemGray3.cgColor
        createdTableView.layer.borderWidth = 3
        
        createdTableView.isHidden = true
        createdTableView.allowsSelection = false
        createdTableView.isScrollEnabled = false
        
        view.addSubview(createdTableView)
        createdTableView.translatesAutoresizingMaskIntoConstraints = false
        createdTableView.topAnchor.constraint(equalTo: createdEventsButton.bottomAnchor, constant: 10).isActive = true
        createdTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        createdTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100).isActive = true
        createdTableView.widthAnchor.constraint(equalToConstant: view.frame.width/2-10).isActive = true
    }
    
    func getMyEvents(){
        for eventID in myCreatedEvents{
            if let event = events[eventID]{
                myEvents[0].append(event)
            }
        }
        for eventID in joinedEvents{
            if let event = events[eventID]{
                myEvents[1].append(event)
            }
        }
        
    }
    
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var createdEventsButton: UIButton!
    @IBOutlet weak var joinedEventsButton: UIButton!
    @IBOutlet weak var username: UILabel!
    var imagePicker : UIImagePickerController?
    
    @IBAction func createdEvents(_ sender: UIButton) {
        
        createdTableView.isHidden = !createdTableView.isHidden
        createdTableView.allowsSelection = !createdTableView.allowsSelection
        createdTableView.isScrollEnabled = !createdTableView.isScrollEnabled
        
    }
    @IBOutlet weak var profilePic: UIButton!
    
    @IBAction func upcomingEvents(_ sender: UIButton) {
        print("Upcoming events should open")
        joinedTableView.isHidden = !joinedTableView.isHidden
        joinedTableView.allowsSelection = !joinedTableView.allowsSelection
        joinedTableView.isScrollEnabled = !joinedTableView.isScrollEnabled
        
    }
    @IBAction func myFriends(_ sender: UIButton) {
        guard let myFriendsVC = storyboard?.instantiateViewController(identifier: "MyFriendsViewController") else {return}
        navigationController?.pushViewController(myFriendsVC, animated: true)
        
    }
    @IBAction func changeProfilePic(_ sender: UIButton) {
        self.present(imagePicker!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        navigationController?.hidesBarsOnTap = false
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = .systemGray5
        username.text = Auth.auth().currentUser?.displayName
        username.textColor = UIColor(red: 43/255.0, green: 183/255.0, blue: 183/255.0, alpha: 1.0)
        setUpProfilePic()
        setUpImagePicker()
        getMyEvents()
        setUpJoinedTableView()
        setUpCreatedTableView()
        appIcon.layer.masksToBounds = false
        appIcon.clipsToBounds = true
        appIcon.layer.cornerRadius = appIcon.frame.height/4
        super.viewDidLoad()
        
    }
    
    func setUpImagePicker(){
        imagePicker = UIImagePickerController()
        imagePicker?.allowsEditing = true
        imagePicker?.sourceType = .photoLibrary
        imagePicker?.delegate = self
    }
    
    func setUpProfilePic(){
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        profilePic.setImage(userImage, for: .normal)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            //profilePic.setImage(pickedImage, for: .normal)
            userImage = pickedImage
            profilePic.setImage(userImage, for: .normal)
            uploadProfilePicture(pickedImage) {url in
                guard let uid = Auth.auth().currentUser?.uid else {return}
                guard let imageURL = url else {return}
                databaseRef.child("users/\(uid)").updateChildValues(["imageURL" : imageURL.absoluteString])
                databaseRef.child("userProfiles/\(uid)").updateChildValues(["imageURL" : imageURL.absoluteString])
            }
            
        }
        imagePicker?.dismiss(animated: true, completion: nil)
    }
    
    func uploadProfilePicture(_ image: UIImage, _ completion: @escaping((_ url:URL?) -> ())){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let userStorage = storageRef.child("Profile Pic /\(uid)")
        guard let image = profilePic.imageView?.image, let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        userStorage.putData(imageData, metadata: StorageMetadata()) { (metaData, error) in
            if error == nil && metaData != nil{
                userStorage.downloadURL { (url, error) in
                    guard let downloadUrl = url else {return}
                    completion(downloadUrl)
                }
            }
            else{
                completion(nil)
            }
        }
        
    }
    
    
    @IBAction func SidebarButtonTapped(_ sender: UIBarButtonItem) {
        print("Aha..?")
        slideOutSidebar(self)
    }
    
}

