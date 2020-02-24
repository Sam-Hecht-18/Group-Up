//
//  SidebarMenuViewController.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 2/24/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit

class SidebarMenuViewController: UIViewController {
        enum MenuType: Int{
            case home
            
        }
        override func viewDidLoad() {
            super.viewDidLoad()

            overrideUserInterfaceStyle = .dark
        }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let menuType = MenuType(rawValue: indexPath.row) else {return}
            dismiss(animated: true ){
                print("dismissed: \(menuType)")
            }
        }
    }
