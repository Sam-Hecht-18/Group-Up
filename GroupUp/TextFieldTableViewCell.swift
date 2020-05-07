//
//  TextFieldTableViewCell.swift
//  GroupUp
//
//  Created by Samuel Hecht (student LM) on 4/8/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    let textField = UITextField()
    func configure(text: String?, placeholder: String){
        self.addSubview(textField)
        
        
    }
    

}
