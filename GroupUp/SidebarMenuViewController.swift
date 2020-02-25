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
        let tableViewMenu = UITableView(frame: CGRect.zero, style: .grouped)
        let tableViewMenuCell = UITableViewCell()
        let homeImageView = UIImageView(image: UIImage(named: "Home"))
        let homeLabel = UILabel()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            tableViewMenu.delegate = self
            //overrideUserInterfaceStyle = .dark
            view.addSubview(tableViewMenu)
            view.addSubview(tableViewMenuCell)
            
            //tableViewMenu.addSubview(tableViewMenuCell)
            tableViewMenuCell.contentView.addSubview(homeImageView)
            tableViewMenuCell.contentView.addSubview(homeLabel)
            tableViewMenu.separatorStyle = .none
            
            homeImageView.translatesAutoresizingMaskIntoConstraints = false
            homeImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            homeImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            homeImageView.leadingAnchor.constraint(equalTo: tableViewMenuCell.contentView.leadingAnchor, constant: 16).isActive = true
            homeImageView.centerYAnchor.constraint(equalTo: tableViewMenuCell.contentView.centerYAnchor, constant: 0).isActive = true
            
            homeLabel.translatesAutoresizingMaskIntoConstraints = false
            homeLabel.leadingAnchor.constraint(equalTo: homeImageView.trailingAnchor, constant: 16).isActive = true
            
            homeLabel.centerYAnchor.constraint(equalTo: homeImageView.centerYAnchor, constant: 0).isActive = true
            
            homeLabel.text = "CASA"
            
            
            
            
        }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let menuType = MenuType(rawValue: indexPath.row) else {return}
            dismiss(animated: true ){
                print("dismissed: \(menuType)")
            }
        }
    }
