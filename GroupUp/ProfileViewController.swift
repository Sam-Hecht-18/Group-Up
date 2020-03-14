//
//  ProfileViewController.swift
//  GroupUp
//
//  Created by Eli Forman (student LM) on 3/4/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import FirebaseStorage
import MapKit
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    
    @IBOutlet weak var username: UILabel!
    var imagePicker : UIImagePickerController?
    
    @IBAction func FirebaseTestPull(_ sender: UIButton) {
        if let mapViewContoller = navigationController?.viewControllers[0] as? MapViewController{
            let eventsStorage = storageRef.child("Events /")
            //eventsStorage is a reference to all of the events in firebaes
            eventsStorage.listAll { (allEvents, error) in
                if error != nil{
                    print("Uh damn uh... ham uh...")
                    print(error)
                }
                else{
                    //allEvents is the reference to all the event in firebase
                    
                    print("The count is: \(allEvents.prefixes.count)")
                    for i in 0..<allEvents.prefixes.count{
                        //allEvents.ites[i] is a singular event named by their index
                        let eventStorageRef = allEvents.prefixes[i]
                        print("The name of the event is: \(eventStorageRef.name)")
                        //locationStorageRef is the reference to the location child of the event itself
                        //HERE IS WHERE OTHER STORAGE THINGS SHOULD BE USED
                        //TO GET OTHER DATA LIKE NAME TIME CREATOR ETC.
                        let locationStorageRef = eventStorageRef.child("Location")
                        locationStorageRef.getData(maxSize: 1024*1024) { (data, error) in
                            if error != nil{
                                print("Uh damn uh... ham uh... but in the THING!")
                                print(error)
                            }
                            else{
                                guard let data = data else {return}
                                guard let location = String(data: data, encoding: .utf8) else {return}
                                let characters = location.split(separator: ",", maxSplits: 2, omittingEmptySubsequences: true)
                                let latitude = Double(characters[0]) ?? 0
                                let longitude = Double(characters[1]) ?? 0
                                mapViewContoller.map.addAnnotation(customPin(pinTitle: "Here is \(i)", pinSubtitle: "YOU DID IT", location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
                                print("You are the one")
                                }
                               
                                
                            }
                        }
                    }
                    
                }
            }
//            locationStorage.getData(maxSize: 1024*1024) { (data, error) in
//                if error != nil{
//                    print("Uh damn uh... ham uh...")
//                    print(error)
//                }
//                else{
//                    guard let data = data else {return}
//                    let newLocationString = String(data: data, encoding: .utf8)
//                    if let theLocation = newLocationString{
//                        let characters = theLocation.split(separator: ",", maxSplits: 2, omittingEmptySubsequences: true)
//
//                        let latitude = Double(characters[0].dropFirst()) ?? 0
//                        let longitude = Double(characters[1].dropLast()) ?? 0
//                        mapViewContoller.map.addAnnotation(customPin(pinTitle: "OMG", pinSubtitle: "YOU DID IT", location: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
//                    }
//
//
//                }
//            }
//        }
    }
    @IBAction func firebaseTestPush(_ sender: UIButton) {
        //if let mapViewContoller = navigationController?.viewControllers[0] as? MapViewController{
            let location = CLLocationCoordinate2D(latitude: 40.0423, longitude: -75.3167)
            let locationString = "\(location.latitude),\(location.longitude)"
            let locationStorage = storageRef.child("Events /0 /Location")
            print("Location string is: \(locationString)")
            print("Bye")
            guard let encodedString = locationString.data(using: String.Encoding.utf8)?.base64EncodedString() else {return}
            print("HELLO! and this is encoded String: \(encodedString)")
            guard let locationData = Data(base64Encoded: encodedString) else {return}
            print("Um")
            locationStorage.putData(locationData, metadata: StorageMetadata()) { (metadata, error) in }
            
            
//            mapViewContoller.map.addAnnotation(customPin(pinTitle: "No way", pinSubtitle: "you did it", location: location))
        //}
        
    }
            //if let mapViewContoller = navigationController?.viewControllers[0] as? MapViewController{
    @IBAction func FirebaseTestPush2(_ sender: UIButton) {
        let location = CLLocationCoordinate2D(latitude: 40.0102, longitude: -75.2797)
        let locationString = "\(location.latitude),\(location.longitude)"
        let locationStorage = storageRef.child("Events /1 /Location")
        print("Location string is: \(locationString)")
        print("Bye")
        guard let encodedString = locationString.data(using: String.Encoding.utf8)?.base64EncodedString() else {return}
        print("HELLO! and this is encoded String: \(encodedString)")
        guard let locationData = Data(base64Encoded: encodedString) else {return}
        print("Um")
        locationStorage.putData(locationData, metadata: StorageMetadata()) { (metadata, error) in }
    }
    
                
                
    //            mapViewContoller.map.addAnnotation(customPin(pinTitle: "No way", pinSubtitle: "you did it", location: location))
            //}
            
        
    
    @IBOutlet weak var profilePic: UIButton!
    
    @IBAction func changeProfilePic(_ sender: UIButton) {
        self.present(imagePicker!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        navigationController?.hidesBarsOnTap = false
        overrideUserInterfaceStyle = .dark
        username.text = authRef.currentUser?.displayName
        setUpProfilePic()
        setUpImagePicker()
        
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
        if profilePic.imageView?.image == UIImage(){
            print("Yeee")
            profilePic.setImage(UIImage(named: "ProfilePic"), for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userImageUnwrapped = userImage{
            self.profilePic.setImage(userImageUnwrapped, for: .normal)
        }
        else{
            print("this happens everytime")
            getProfilePic()
            if let userImageUnwrapped = userImage{
                self.profilePic.setImage(userImageUnwrapped, for: .normal)
            }
            
            // Do any additional setup after loading the view.
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profilePic.setImage(pickedImage, for: .normal)
            userImage = profilePic.imageView?.image
            uploadProfilePicture(pickedImage) {url in}
        }
        imagePicker?.dismiss(animated: true, completion: nil)
    }
    
    func uploadProfilePicture(_ image: UIImage, _ completion: @escaping((_ url:URL?) -> ())){
        guard let uid = authRef.currentUser?.uid else {return}
        let userStorage = storageRef.child("Profile Pic /\(uid)")
        guard let image = profilePic.imageView?.image, let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        userStorage.putData(imageData, metadata: StorageMetadata()) { (metaData, error) in }
        
    }
    
    @IBAction func SidebarButtonTapped(_ sender: UIBarButtonItem) {
        slideOutSidebar(self)
    }
    
}

