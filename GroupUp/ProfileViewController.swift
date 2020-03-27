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
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var username: UILabel!
    var imagePicker : UIImagePickerController?
    
    @IBAction func FirebaseTestPull(_ sender: UIButton) {
       
    }
    @IBAction func firebaseTestPush(_ sender: UIButton) {

    }
    @IBAction func FirebaseTestPush2(_ sender: UIButton) {
        
    }
    
    
    @IBOutlet weak var profilePic: UIButton!
    
    @IBAction func changeProfilePic(_ sender: UIButton) {
        self.present(imagePicker!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        navigationController?.hidesBarsOnTap = false
        overrideUserInterfaceStyle = .dark
        username.text = Auth.auth().currentUser?.displayName
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
        slideOutSidebar(self)
    }
    
}

