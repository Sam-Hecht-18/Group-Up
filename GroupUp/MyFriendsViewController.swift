//
//  MyFriendsViewController.swift
//  GroupUp
//
//  Created by Eli Forman (student LM) on 4/29/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit

class MyFriendsViewController: UITableViewController {
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 150, y: -20, width: 100, height: 100))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        tableView.separatorColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "friendCell")
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(red: 208/255.0, green: 222/255.0, blue: 39/255.0, alpha: 1.0)
        view.addSubview(activityIndicator)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let _ = scrollView as? UITableView{
            activityIndicator.stopAnimating()
            tableView.reloadData()
            
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let tabView = scrollView as? UITableView{
            
            if(tabView.contentOffset.y < 0 && tabView.isDragging){
                activityIndicator.startAnimating()
            }
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 1)
        let view = UIView(frame: frame)
        view.backgroundColor = .clear
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 50 : 2
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return myFriends.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") else {return UITableViewCell()}
        let friendUID = myFriends[indexPath.section]
        guard let friendUsername = UIDToUsername[friendUID] else {
            print("failed 1")
            return cell}
        guard let attributedProfileText = usernameToFormattedProfile[friendUsername] else {
            print("failed 2")
            return cell}
        cell.textLabel?.attributedText = attributedProfileText
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        cell.layer.borderWidth = 3
        cell.backgroundColor = .systemGray3
        return cell
    }

 

}
