//
//  StartUpScreenViewController.swift
//  GroupUp
//
//  Created by Vikas Miller (student LM) on 2/24/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class StartUpScreenViewController: UIViewController,UINavigationControllerDelegate {

    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true

    }
    @IBAction func LogIn(_ sender: UIButton) {
        print("hello")
        guard let logInViewController = storyboard?.instantiateViewController(withIdentifier: "LogInViewController") else {return}
        print("and we here dawg")
         navigationController?.pushViewController(logInViewController, animated: true)
        print("And we even here dawg")
    }
    
    @IBAction func SignUp(_ sender: UIButton) {
        guard let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") else {return}
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
