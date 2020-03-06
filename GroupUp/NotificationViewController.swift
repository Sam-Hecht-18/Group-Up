//
//  NotificationViewController.swift
//  GroupUp
//
//  Created by Vikas Miller (student LM) on 3/6/20.
//  Copyright © 2020 Samuel Hecht (student LM). All rights reserved.
//

import UIKit
import UserNotifications
class NotificationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let content = UNMutableNotificationContent()
        content.title = "Best Mentor"
        content.body = "Keep up the good work"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:  5, repeats: true)
        //UNCalendarNotificationTrigger
        //- Specify Date and time for notification
        //UNLocationNotificationTrigger
        //- Specify location where user will receive notifications
        
        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
