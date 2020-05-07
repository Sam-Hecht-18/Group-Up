//
//  SignUpViewController.swift
//  GroupUp
//
//  Created by Seth Richards (student LM) on 2/24/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func signUpButton(_ sender: UIButton) {
        guard let email = emailAddressTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let name = usernameTextField.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password){ (user, error) in
            if let _ = user{
                print("user created")
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges(completion: {(error) in print("couldnt change name")
                    
                })
                guard let uid = Auth.auth().currentUser?.uid else {return}
                let newUser = ["username" : name]
                databaseRef.child("users/\(uid)").updateChildValues(newUser)
                databaseRef.child("userProfiles/\(uid)").updateChildValues(newUser)
                resetEverything()
                self.navigationController?.popToRootViewController(animated: true)
            }
            else{
                print(error.debugDescription)
            }
        }
    }
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        setUpTextFields()
        signUpButton.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    func setUpTextFields(){
        usernameTextField.delegate = self
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
        
        emailAddressTextField.autocorrectionType = .no
        passwordTextField.autocorrectionType = .no
        usernameTextField.autocorrectionType = .no
        
        usernameTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if usernameTextField.isFirstResponder{
            usernameTextField.resignFirstResponder()
            emailAddressTextField.becomeFirstResponder()
        }
        else if emailAddressTextField.isFirstResponder{
            emailAddressTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        else{
            passwordTextField.resignFirstResponder()
            signUpButton.isEnabled = true
        }
        return true
    }
    
}

