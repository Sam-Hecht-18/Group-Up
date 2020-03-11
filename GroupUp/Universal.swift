import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit

//  Universal.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 3/10/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//
var databaseRef = Database.database().reference()
var storageRef = Storage.storage().reference()
var authRef = Auth.auth()

let transition = SlideInTransition()
let universe = Universal()
var userImage: UIImage?

func getProfilePic(){
    guard let uid = authRef.currentUser?.uid else {return}
    storageRef.child("user /\(uid)").getData(maxSize: 1024*1024) { (data, error) in
        guard let unwrappedData = data else {return}
        userImage = UIImage(data: unwrappedData)
        if error != nil {
            print("You have no pic lmao")
        }
    }
}

func transitiontoNewVC(_ menuType: MenuType, currentViewController: UIViewController){
    //I have a feeling that we'll want to pop to the root before doing any other thing
    //Might have to change the animation stuff tho cuz we won't want the user seeing that
    //This would mean that we uncomment the line below
    //And get rid of the .map case
    //Task for another day
    
    //currentViewController.navigationController?.popToRootViewController(animated: true)
    switch menuType{
    case .map:
        currentViewController.navigationController?.popToRootViewController(animated: true)
    case .profile:
        guard let profileViewController = currentViewController.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") else {return}
        currentViewController.navigationController?.pushViewController(profileViewController, animated: true)
    case .logOut:
        do{
            try authRef.signOut()
        }
        catch{
            print("shoot")
        }
        guard let startUpViewController = currentViewController.storyboard?.instantiateViewController(withIdentifier: "StartUpScreenViewController") else {return}
        currentViewController.navigationController?.pushViewController(startUpViewController, animated: true)
    //Why is default never executed?
    default:
        break
    }
}

func slideOutSidebar(_ currentViewController: UIViewController){
    guard let sidebarMenuViewController = currentViewController.storyboard?.instantiateViewController(withIdentifier: "SidebarMenuViewController") as? SidebarMenuViewController else {return}
    sidebarMenuViewController.didTapMenuType = {menuType in
        transitiontoNewVC(menuType, currentViewController: currentViewController)
    }
    sidebarMenuViewController.modalPresentationStyle = .overCurrentContext
    sidebarMenuViewController.transitioningDelegate = universe
    currentViewController.present(sidebarMenuViewController, animated: true)
    //Yo idk if you fellas want this but at least while the
    //Event manager is empty it looks bad with both up cuz the
    //Map gets blocked so...
    if let mapViewController = currentViewController as? MapViewController{
        mapViewController.eventManagerSlideUpView.popUpViewToBottom()
    }
    
}

class Universal: NSObject, UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}

