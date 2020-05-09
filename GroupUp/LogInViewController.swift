//
//  LogInViewController.swift
//  GroupUp
//
//  Created by Seth Richards (student LM) on 2/24/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import MapKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        guard let email = usernameTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password){(user, error) in
            if error == nil && user != nil{
                
                self.navigationController?.popToRootViewController(animated: true)
                print("uhh I hope so")
                downloadPicture()
                resetEverything()
                
            }
            else{
                print(error!.localizedDescription)
                
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameTextField.isFirstResponder {
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        else{
            passwordTextField.resignFirstResponder()
            logInButton.isEnabled = true
        }
        return true
    }
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        setUpTextFields()
        logInButton.isEnabled = false
    }
    func setUpTextFields(){
        usernameTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.becomeFirstResponder()
        let placeHolder = NSAttributedString(string: "Must be at least 6 characters", attributes: [NSAttributedString.Key.foregroundColor : UIColor.systemGray2])
        passwordTextField.attributedPlaceholder = placeHolder
    }
    
    
    
    
}
