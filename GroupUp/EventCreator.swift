//
//  EventCreator.swift
//  GroupUp
//
//  Created by Seth Richards (student LM) on 3/4/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import Foundation
import UIKit

class EventCreator: UIViewController{
    let label = UILabel()

    override func viewDidLoad() {
        view.backgroundColor = UIColor.black

    
        label.textColor = UIColor.white
        label.text = "New Event"
        label.frame = CGRect(x: 30, y: 30, width: 250, height: 30)
        label.font = UIFont(name: "Arial", size: 35)

        self.view.addSubview(label)
        
    }
    
    
}
