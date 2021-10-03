//
//  localNotificationManager.swift
//  ToDoList
//
//  Created by Mohsin Braer on 10/3/21.
//

import Foundation
import UserNotifications

struct LocalNotificationManger{
    
    static func authorizeLocalNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard error == nil else{
                print("ERROR: \(error!.localizedDescription)");
                return
            }
            if granted {
                print("Notifications Authorization Granted!");
                
            } else{
                print("Notification Authorization NOT Granted");
                //put alert
            }
        }
    }
    
    static func setCalendarNotification(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
        
        let content = UNMutableNotificationContent()
        content.title = title;
        content.subtitle = subtitle;
        content.body = body;
        content.sound = sound;
        content.badge = badgeNumber;
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date);
        dateComponents.second = 00;
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let notificationID = UUID().uuidString;
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger);
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription), adding notification request went wrong");
            } else{
                print("Notification scheduled \(notificationID), title: \(content.title)");
            }
            
        }
        
        return notificationID
    }
    
   
}
