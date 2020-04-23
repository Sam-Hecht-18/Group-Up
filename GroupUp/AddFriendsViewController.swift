//
//  AddFriendsViewController.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 4/22/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
class AddFriendsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    let textField = UITextField()
    let tableView = UITableView()
    var uids = [String]()
    var friendProfiles = [String: NSMutableAttributedString]()
    var usernames = [String]()
    var viableUsernames = [String]()
    var deleted = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("hello")
        view.backgroundColor = .systemGray5
        
        updateUids()
       
        
        print("Right before ausdfbiunui")
        print("Uids count is: \(uids.count)")
        
        // Do any additional setup after loading the view.
    }
    @objc func textChanged(){
        tableView.reloadData()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        deleted = string.count == 0
        return true
    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        print("EDITING")
//        deleted = textField.text?.count ?? 0 < prevText.count
//        print("DELETED IS \(deleted)")
//        prevText = textField.text ?? prevText
//        tableView.reloadData()
//    }
    
    func createImageAndUsernameText(image: UIImage, username: NSAttributedString, usernameText: String){
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let imageOffsetY: CGFloat = -10.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 40, height: 40)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeName = NSMutableAttributedString(string: "")
        completeName.append(attachmentString)
        completeName.append(username)
        friendProfiles.updateValue(completeName, forKey: usernameText)
    }
    
    func updateUids(){
        
        print("SUP DAWG")
        print("1")
        print("2")
        
        databaseRef.child("users").observeSingleEvent(of: .value) { (snapshot) in
            print("3")
            guard let usersUnwrapped = snapshot.value as? [String: Any] else {
                print("4")
                return}
            print("there are: \(usersUnwrapped.keys.count) keys apparently" )
            for uid in usersUnwrapped.keys{
                self.uids.append(uid)
                print("Cinco")
                guard let userData = usersUnwrapped[uid] as? [String: Any] else {
                    print("Mama mia")
                    print(usersUnwrapped[uid])
                    return
                    
                }
                
                print("Seis")
                guard let usernameString = userData["username"] as? String else {
                    print("siete")
                    return
                    
                }
                let username = NSAttributedString(string: "  \(usernameString)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.systemPink])
                
                
                guard let imageURL = userData["imageURL"] as? String else {
                    print("Uh oh")
                    self.createImageAndUsernameText(image: UIImage(named: "ProfilePic")!, username: username,usernameText: usernameString)
                    continue}
                self.usernames.append(usernameString)
                let ref = Storage.storage().reference(forURL: imageURL)
                ref.getData(maxSize: 1024*1024) { (data, error) in
                    if error == nil && data != nil{
                        self.createImageAndUsernameText(image: UIImage(data: data!)!, username: username, usernameText: usernameString)
                        
                        
                        
                        print("6")
                        
                        print("7")
                        
                    }
                    else{
                        print(error?.localizedDescription)
                    }
                }
            }
            print("5")
            self.setUpTextField()
            print("8")
            
            //self.populateTableView()
            print("9")
            
            self.usernames.sort()
            print("10")
            self.viableUsernames = self.usernames
            print("11")
            self.setUpTableView()
            //friends = usersUnwrapped
            
            
        }
        
        
    }
    func populateTableView(){
        print("REEEE")
        for i in 0..<uids.count{
            print("right before heuh")
            let uid = uids[i]
            print("Hidy ho everyone")
            downloadPicture(withUser: uid) {(image) in
                print("Non noono")
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = image
                let imageOffsetY: CGFloat = -10.0
                imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 40, height: 40)
                let attachmentString = NSAttributedString(attachment: imageAttachment)
                let completeName = NSMutableAttributedString(string: "")
                completeName.append(attachmentString)
                
                databaseRef.child("users/\(uid)/username").observeSingleEvent(of: .value) { (snapshot) in
                    guard let usernameUnwrapped = snapshot.value as? String else {return}
                    self.usernames.append(usernameUnwrapped)
                    let username = NSAttributedString(string: "  \(usernameUnwrapped)", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20), NSAttributedString.Key.foregroundColor : UIColor.systemPink])
                    completeName.append(username)
                    self.friendProfiles.updateValue(completeName, forKey: usernameUnwrapped)
                    print("the count is \(self.friendProfiles.count)")
                    print("the i is \(i)")
                    print("Congratulations!")
                    self.usernames.sort()
                    print("10")
                    self.viableUsernames = self.usernames
                    print("11")
                    self.setUpTableView()
                    print("12")
                    
                }
            }
        }
    }
    func setUpTextField(){
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.frame = CGRect(x: 0, y: 0, width: view.frame.width-100, height: 150)
        textField.textColor = .black
        textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        textField.widthAnchor.constraint(equalToConstant: view.frame.width-100).isActive = true
        
        textField.backgroundColor = .white
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
    }
    
    func setUpTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 700).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        tableView.backgroundColor = .systemGray5
        tableView.layer.cornerRadius = 10
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentText = textField.text?.lowercased() else{
            print("Hello")
            viableUsernames = usernames
            return viableUsernames.count
        }
        if currentText.isEmpty{
            print("Goodbye")
            viableUsernames = usernames
        }
        else if deleted{
            print("Uh oh deleted")
            for i in 0..<usernames.count{
                if usernames[i].contains(currentText) && !viableUsernames.contains(usernames[i]){
                    viableUsernames.append(usernames[i])
                }
            }
        }
        else{
            for i in stride(from: viableUsernames.count-1, to: -1, by: -1){
                print("Prev text is: \(currentText) and the viable username is: \(viableUsernames[i])")
                if !viableUsernames[i].contains(currentText){
                    viableUsernames.remove(at: i)
                }
            }
        }
        return viableUsernames.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {return UITableViewCell()}
        
        cell.textLabel?.attributedText = friendProfiles[viableUsernames[indexPath.row]]
        return cell
        
    }
}
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


