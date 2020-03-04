//
//  SidebarMenuViewController.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 2/24/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
enum MenuType: Int{
    case map
    case profile
}
class SidebarMenuViewController: UITableViewController {
    var didTapMenuType: ((MenuType) -> Void)?
    
        override func viewDidLoad() {
            super.viewDidLoad()
            overrideUserInterfaceStyle = .dark

        }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("what the fudeg")
            guard let menuType = MenuType(rawValue: indexPath.row) else {return}
            dismiss(animated: true ){ [weak self] in
                print("dismissed: \(menuType)")
                self?.didTapMenuType?(menuType)
            }
        }
    }
