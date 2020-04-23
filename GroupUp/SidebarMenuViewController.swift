//
//  SidebarMenuViewController.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 2/24/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
enum MenuType: Int{
    case map
    case profile
    case logOut
    case friendsManager
}
class SidebarMenuViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    func setUpPanGesture(){
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(SidebarMenuViewController.panGesture))
        view.addGestureRecognizer(gesture)
    }
    @objc func panGesture(recognizer : UIPanGestureRecognizer){
        print("hello")
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let x = self.view.frame.minX
        
        //Value of where the final x position will be
        let finalXPosition = translation.x + x
        //Checks to make sure that the final xposition is in a legal place
        if finalXPosition > -view.frame.width  && finalXPosition < 0{
            //If so, changes the view with the gesture
            view.frame = CGRect(x: finalXPosition, y: 0, width: view.frame.width, height: view.frame.height)
            //Resets the translation to zero so it stops doing the translation
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
        if recognizer.state == .ended{
            var duration : Double
            
            //v = d/t  ->  t = d/v
            duration = velocity.x < 0 ? Double((view.frame.width + x) / -velocity.x) : Double((-x) / velocity.x)
            //If the duration > 0.5, make it 0.5, otherwise leave it
            duration = duration > 0.5 ? 0.5 : duration
            //Animates it either closed or back open and dismisses itself
            //If it closes once its completion gets handled
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if(velocity.x < 0){
                    self.view.frame = CGRect(x: -self.view.frame.width, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
                else{
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }
            })
            { _ in
                
                if velocity.x < 0{
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    var didTapMenuType: ((MenuType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPanGesture()
        setUpBarline()
        
        //overrideUserInterfaceStyle = .dark
        
    }
    func setUpBarline(){
        let barline = UIImageView(image: UIImage(named: "BarlineVert"))
        view.addSubview(barline)
        let centerXAnchor = view.centerXAnchor
        let centerYAnchor = view.centerYAnchor
        barline.translatesAutoresizingMaskIntoConstraints = false
        barline.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 155).isActive = true
        barline.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        barline.widthAnchor.constraint(equalToConstant: 11).isActive = true
        barline.heightAnchor.constraint(equalToConstant: 38).isActive = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else {return}
        dismiss(animated: true ){ [weak self] in
            print("dismissed: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
    }
}
