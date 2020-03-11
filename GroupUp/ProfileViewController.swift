//
//  ProfileViewController.swift
//  GroupUp
//
//  Created by Eli Forman (student LM) on 3/4/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import FirebaseStorage
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var username: UILabel!
    var imagePicker : UIImagePickerController?
    
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userImageUnwrapped = userImage{
            self.profilePic.setImage(userImageUnwrapped, for: .normal)
        }
        else{
            print("this happens everytime")
            getProfilePic()
            self.profilePic.setImage(userImage, for: .normal)
            
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
        let userStorage = storageRef.child("user /\(uid)")
        guard let image = profilePic.imageView?.image, let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        userStorage.putData(imageData, metadata: StorageMetadata()) { (metaData, error) in }
        
    }
    
    @IBAction func SidebarButtonTapped(_ sender: UIBarButtonItem) {
        slideOutSidebar(self)
    }
    
}

