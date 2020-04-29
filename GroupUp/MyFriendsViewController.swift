//
//  MyFriendsViewController.swift
//  GroupUp
//
//  Created by Eli Forman (student LM) on 4/29/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit

class MyFriendsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "friendCell")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFriends.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Hello I'm alex")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") else {return UITableViewCell()}
        let friendUID = myFriends[indexPath.row]
        guard let friendUsername = UIDToUsername[friendUID] else {
            print("failed 1")
            return cell}
        guard let attributedProfileText = usernameToFormattedProfile[friendUsername] else {
            print("failed 2")
            return cell}
        cell.textLabel?.attributedText = attributedProfileText
        cell.backgroundColor = .cyan
        return cell
    }

 

}
