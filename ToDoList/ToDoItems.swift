//
//  ToDoItems.swift
//  ToDoList
//
//  Created by Mohsin Braer on 10/3/21.
//

import Foundation
import UserNotifications

class ToDoItems{
    var itemsArray: [ToDoItem] = []
    
    func saveData(){
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json");
        let jsonEncoder = JSONEncoder();
        let data = try? jsonEncoder.encode(itemsArray);
        do {
            try data?.write(to: documentURL, options: .noFileProtection);
        } catch
        {
            print("ERROR: could not save data \(error.localizedDescription)");
        }
        
        setNotifications();
        
    }
    
    func loadData(completed: @escaping () -> ()){
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json");
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do{
            itemsArray = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
        } catch{
            print("ERROR: could not save data \(error.localizedDescription)");
            
        }
        
        completed();
        
    }
    
    func setNotifications(){
        
        guard itemsArray.count > 0 else{
            return
        }
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for index in 0..<itemsArray.count{
            if itemsArray[index].reminderSet{
                let toDoItem = itemsArray[index]
                itemsArray[index].notificationID = LocalNotificationManger.setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
            }
        }
        
    }
}
