//
//  StartUpScreenViewController.swift
//  GroupUp
//
//  Created by Vikas Miller (student LM) on 2/24/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit


class StartUpScreenViewController: UIViewController,UINavigationControllerDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationController?.navigationBar.isHidden = true
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
    
    
    
}
