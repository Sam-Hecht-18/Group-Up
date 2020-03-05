//
//  ProfileViewController.swift
//  GroupUp
//
//  Created by Eli Forman (student LM) on 3/4/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePicker : UIImagePickerController?
    
    
    @IBOutlet weak var profilePic: UIButton!
    @IBAction func changeProfilePic(_ sender: UIButton) {
        self.present(imagePicker!, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
    

        imagePicker = UIImagePickerController()
        imagePicker?.allowsEditing = true
        imagePicker?.sourceType = .photoLibrary
        imagePicker?.delegate = self
        
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.black.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker?.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            profilePic.setImage(pickedImage, for: .normal)
            uploadProfilePicture(pickedImage) {url in}
        }
        imagePicker?.dismiss(animated: true, completion: nil)
    }
    func uploadProfilePicture(_ image: UIImage, _ completion: @escaping((_ url:URL?) -> ())){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storage = Storage.storage().reference().child("user /\(uid)")
        guard let image = profilePic.imageView?.image, let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        storage.putData(imageData, metadata: StorageMetadata()) { (metaData, error) in }
        
    }
      @IBAction func SidebarButtonTapped(_ sender: UIBarButtonItem) {
    
     // let sidebarMenuViewController = SidebarMenuViewController()
          guard let sidebarMenuViewController = storyboard?.instantiateViewController(withIdentifier: "SidebarMenuViewController") as? SidebarMenuViewController else {return}
          sidebarMenuViewController.didTapMenuType = {menuType in
              self.transitiontoNewVC(menuType)
          }
          sidebarMenuViewController.modalPresentationStyle = .overCurrentContext
          sidebarMenuViewController.transitioningDelegate = self
          present(sidebarMenuViewController, animated: true)
      }
      func transitiontoNewVC(_ menuType: MenuType){

          
          switch menuType{
          case .map:
            guard let mappyViewController = storyboard?.instantiateViewController(withIdentifier: "MapViewController") else {return}
           weak var pvc = self.presentingViewController

            self.dismiss(animated: true, completion: {
                
                pvc?.present(mappyViewController, animated: true, completion: nil)
            })
          default:
            break
          }
      }
      
      
      let transition = SlideInTransition()
}
extension ProfileViewController : UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

