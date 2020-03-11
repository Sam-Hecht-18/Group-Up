//
//  EventCreator.swift
//  GroupUp
//
//  Created by Seth Richards (student LM) on 3/4/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit

class EventCreator: UIViewController{
    let label = UILabel()
    let eventName: String = " "
    let eventLocation: String = " "
    let eventDate: String = " "
    let eventTime: String = " "
    //add var for number of people
    //add way to track how many people have already signed up
    
    
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.black
        
        
        label.textColor = UIColor.white
        label.text = "New Event"
        label.frame = CGRect(x: 30, y: 30, width: 250, height: 30)
        label.font = UIFont(name: "Arial", size: 35)
        
        self.view.addSubview(label)
        
        
    }
    
    
}
