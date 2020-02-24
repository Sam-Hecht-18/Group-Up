//
//  SidebarMenuViewController.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 2/24/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit

class SidebarMenuViewController: UITableViewController {
        enum MenuType: Int{
            case home
            
        }
        let tableViewMenu = UITableView()
        let tableViewMenuCell = UITableViewCell()
        let homeImageView = UIImageView(image: UIImage(named: "Home"))
    
        override func viewDidLoad() {
            super.viewDidLoad()
            tableViewMenu.delegate = self
            overrideUserInterfaceStyle = .dark
            homeImageView.translatesAutoresizingMaskIntoConstraints = false
            homeImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            homeImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            homeImageView.leadingAnchor.constraint(equalTo: tableViewMenuCell.contentView.leadingAnchor, constant: 16).isActive = true
            homeImageView.centerYAnchor.constraint(equalTo: tableViewMenuCell.contentView.centerYAnchor, constant: 0).isActive = true
            
            tableViewMenuCell.contentView.addSubview(homeImageView)
            
            
        }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let menuType = MenuType(rawValue: indexPath.row) else {return}
            dismiss(animated: true ){
                print("dismissed: \(menuType)")
            }
        }
    }
