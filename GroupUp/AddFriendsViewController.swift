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
    
    
    @IBAction func sidebarButtonTapped(_ sender: UIBarButtonItem) {
        slideOutSidebar(self)
    }
    let textField = UITextField()
    let tableView = UITableView()
    var showFriendRequests = false
    var deleted = false
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 150, y: 100, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 31/255.0, green: 33/255.0, blue: 36/255.0, alpha: 1.0)
        //viableUsernames = usernames
        //usernames.sort()
        usernames.sort { (arg1, arg2) -> Bool in
            return arg1.lowercased() < arg2.lowercased()
        }
        friendRequestUsernames.sort { (arg1, arg2) -> Bool in
            return arg1.lowercased() < arg2.lowercased()
        }
        for username in usernames{
            print(username)
        }
        viableUsernames = usernames
        setUpTextField()
        setUpTableView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(red: 208/255.0, green: 222/255.0, blue: 39/255.0, alpha: 1.0)
        view.addSubview(activityIndicator)
        let switchTableViewButton = UIBarButtonItem(title: "Friend Requests", style: .plain, target: self, action: #selector(switchTableView))
        navigationItem.rightBarButtonItem = switchTableViewButton
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
    }
    @objc func switchTableView(){
        if showFriendRequests{
            showFriendRequests = false
            navigationItem.rightBarButtonItem?.title = "Friend Requests"
            viableUsernames = usernames
            tableView.reloadData()
            
        }
        else{
            showFriendRequests = true
            navigationItem.rightBarButtonItem?.title = "Add Friends"
            viableUsernames = friendRequestUsernames
            tableView.reloadData()
        }
        print("About to reload data")
    }
    @objc func textChanged(){
        tableView.reloadData()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        deleted = string.count == 0
        return true
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
        tableView.allowsSelection = false
        tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 700).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIColor(red: 31/255.0, green: 33/255.0, blue: 36/255.0, alpha: 1.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellFriends")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellRequests")
        
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let _ = scrollView as? UITableView{
            activityIndicator.stopAnimating()
            tableView.reloadData()
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let tabView = scrollView as? UITableView{
            
            if(tabView.contentOffset.y < 0 && tabView.isDragging){
                activityIndicator.startAnimating()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 1)
        let view = UIView(frame: frame)
        view.backgroundColor = .clear
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        print("About to reload # of rows in section")
        
        switch showFriendRequests{
        case false:
            guard let currentText = textField.text?.lowercased() else{
                viableUsernames = usernames
                return viableUsernames.count
            }
            if currentText.isEmpty{
                viableUsernames = usernames
            }
            else if deleted{
                for i in 0..<usernames.count{
                    if usernames[i].lowercased().hasPrefix(currentText) && !viableUsernames.contains(usernames[i]){
                        viableUsernames.append(usernames[i])
                    }
                }
            }
            else{
                for i in stride(from: viableUsernames.count-1, to: -1, by: -1){
                    if !viableUsernames[i].lowercased().hasPrefix(currentText){
                        viableUsernames.remove(at: i)
                    }
                }
            }
            return viableUsernames.count
            
        case true:
            print("Hi welcome to this part")
            
            guard let currentText = textField.text?.lowercased() else{
                viableUsernames = friendRequestUsernames
                return viableUsernames.count
            }
            if currentText.isEmpty{
                viableUsernames = friendRequestUsernames
                print("And this is the one")
            }
            else if deleted{
                for i in 0..<usernames.count{
                    if friendRequestUsernames[i].lowercased().hasPrefix(currentText) && !viableUsernames.contains(friendRequestUsernames[i]){
                        viableUsernames.append(friendRequestUsernames[i])
                    }
                }
            }
            else{
                for i in stride(from: viableUsernames.count-1, to: -1, by: -1){
                    if !viableUsernames[i].lowercased().hasPrefix(currentText){
                        viableUsernames.remove(at: i)
                    }
                }
            }
            return viableUsernames.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if !showFriendRequests{
            cell = tableView.dequeueReusableCell(withIdentifier: "CellFriends") ?? UITableViewCell()
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "CellRequests") ?? UITableViewCell()
        }
        cell.backgroundColor = .systemGray3
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        if !showFriendRequests{
            cell.textLabel?.attributedText = usernameToFormattedProfile[viableUsernames[indexPath.section]]
            
            cell.contentView.addSubview(setUpAddButton(index: indexPath.section))
            
        }
        else{
            print("Hiya!")
            cell.textLabel?.attributedText = usernameToFormattedProfile[friendRequestUsernames[indexPath.section]]
            
            cell.contentView.addSubview(setUpAcceptButton(index: indexPath.section))
            cell.contentView.addSubview(setUpDenyButton(index: indexPath.section))
            
        }
        
        return cell
    }
    func setUpAddButton(index: Int) -> UIButton{
        let addButton = UIButton(type: .roundedRect)
        
        addButton.backgroundColor = UIColor(red: 172/255.0, green: 207/255.0, blue: 55/255.0, alpha: 1.0)
        addButton.layer.cornerRadius = 10
        addButton.layer.borderWidth = 3
        addButton.layer.borderColor = UIColor(red: 208/255.0, green: 222/255.0, blue: 39/255.0, alpha: 1.0).cgColor
        addButton.frame = CGRect(x: 300, y: 10, width: 100, height: 50)
        let addText = NSAttributedString(string: "Add", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 25)!, NSAttributedString.Key.foregroundColor : UIColor.systemGray3])
        addButton.setAttributedTitle(addText, for: .normal)
        addButton.addTarget(self, action: #selector(addFriend(_:)), for: .touchUpInside)
        addButton.tag = index
        return addButton
    }
    func setUpAcceptButton(index: Int) -> UIButton{
        let acceptButton = UIButton(type: .roundedRect)
        acceptButton.backgroundColor = UIColor(red: 172/255.0, green: 207/255.0, blue: 55/255.0, alpha: 1.0)
        acceptButton.layer.cornerRadius = 10
        acceptButton.layer.borderWidth = 3
        acceptButton.layer.borderColor = UIColor(red: 208/255.0, green: 222/255.0, blue: 39/255.0, alpha: 1.0).cgColor
        acceptButton.frame = CGRect(x: 190, y: 10, width: 100, height: 50)
        let acceptText = NSAttributedString(string: "Accept", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.systemGray3])
        acceptButton.setAttributedTitle(acceptText, for: .normal)
        acceptButton.addTarget(self, action: #selector(acceptRequest(_:)), for: .touchUpInside)
        acceptButton.tag = index
        return acceptButton
        
    }
    func setUpDenyButton(index: Int) -> UIButton{
        let denyButton = UIButton(type: .roundedRect)
        denyButton.backgroundColor = UIColor(red: 172/255.0, green: 207/255.0, blue: 55/255.0, alpha: 1.0)
        denyButton.layer.cornerRadius = 10
        denyButton.layer.borderWidth = 3
        denyButton.layer.borderColor = UIColor(red: 208/255.0, green: 222/255.0, blue: 39/255.0, alpha: 1.0).cgColor
        denyButton.frame = CGRect(x: 300, y: 10, width: 100, height: 50)
        let denyText = NSAttributedString(string: "Deny", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: 20)!, NSAttributedString.Key.foregroundColor : UIColor.systemGray3])
        denyButton.setAttributedTitle(denyText, for: .normal)
        denyButton.addTarget(self, action: #selector(denyRequest(_:)), for: .touchUpInside)
        denyButton.tag = index
        return denyButton
    }
    @objc func acceptRequest(_ acceptButton : UIButton){
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let username = viableUsernames[acceptButton.tag]
        guard let requestUID = usernameToUID[username] else {return}
        databaseRef.child("friendRequests/\(currentUID)/\(username)").removeValue()
        
        databaseRef.child("users/\(currentUID)/friends").observeSingleEvent(of: .value) { (snapshot) in
            guard var friends = snapshot.value as? [String] else{
                databaseRef.child("users/\(currentUID)").updateChildValues(["friends" : [requestUID]])
                print("Request UID is: \(requestUID)")
                return
            }
            friends.append(requestUID)
            databaseRef.child("users/\(currentUID)").updateChildValues(["friends": friends])
        }
        databaseRef.child("users/\(requestUID)/friends").observeSingleEvent(of: .value) { (snapshot) in
            guard var friends = snapshot.value as? [String] else{
                databaseRef.child("users/\(requestUID)").updateChildValues(["friends": [currentUID]])
                return
            }
            friends.append(currentUID)
            databaseRef.child("users/\(requestUID)").updateChildValues(["friends": friends])
        }
        print("Yah yah yahaaaaa")
        friendRequestUsernames.remove(at: acceptButton.tag)
        friendRequests.remove(at: acceptButton.tag)
        viableUsernames = friendRequestUsernames
        textField.text = ""
        tableView.reloadSections([0], with: .automatic)
    }
    @objc func denyRequest(_ denyButton : UIButton){
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let username = viableUsernames[denyButton.tag]
        //guard let requestUID = usernameToUID[username] else {return}
        databaseRef.child("friendRequests/\(currentUID)/\(username)").removeValue()
        friendRequestUsernames.remove(at: denyButton.tag)
        friendRequests.remove(at: denyButton.tag)
        viableUsernames = friendRequestUsernames
        textField.text = ""
        tableView.reloadSections([0], with: .automatic)
    }
    
    @objc func addFriend(_ addButton : UIButton){
        print("Added")
        let toUsername = usernames[addButton.tag]
        guard let toUID = usernameToUID[toUsername] else {
            print("To username is: \(toUsername)")
            return
        }
        guard let currentUID = Auth.auth().currentUser?.uid else {
            print("NO USEr")
            return}
        for key in UIDToUsername.keys{
            print("Key is: \(key)")
        }
        guard let currentUserName = UIDToUsername[currentUID] else {
            print("fuodse")
            return}
        print("Time to request")
        //let request = [toUID: [currentUID: currentUserName]]
        print("Time to update")
        databaseRef.child("friendRequests/\(toUID)").observeSingleEvent(of: .value) { (snapshot) in
            print("Yeah you in here")
            guard var friendReqs = snapshot.value as? [String: String] else {
                databaseRef.child("friendRequests").updateChildValues([toUID: [currentUserName: currentUID]])
                return
            }
            print("Shnaw")
            friendReqs.updateValue(currentUID, forKey: currentUserName)
            databaseRef.child("friendRequests").updateChildValues([toUID: friendReqs])
        }
        //databaseRef.child("friendRequests").updateChildValues(request)
        print("Done!")
        
        usernames.remove(at: addButton.tag)
        viableUsernames = usernames
        textField.text = ""
        tableView.reloadSections([addButton.tag], with: .automatic)
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


