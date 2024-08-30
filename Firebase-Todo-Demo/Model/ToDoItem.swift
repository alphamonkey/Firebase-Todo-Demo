//
//  ToDoItem.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/29/24.
//

import Foundation
import FirebaseFirestore
struct ToDoItem:Codable, Identifiable, Hashable {
    @DocumentID var id:String?
    let guid:UUID
    let uid:String
    var name:String
    var dueDate:Date?
    var description:String?
    var priority:Int?
    var createDate:Date
    var done = false
    
    init(uid:String, name:String, dueDate:Date?, description:String?, priority:Int?) {
        self.guid = UUID()
        self.name = name
        self.dueDate = dueDate
        self.description = description
        self.priority = priority
        self.uid = uid
        self.createDate = Date()
    }
    
    init(uid:String, name:String) {
        self.guid = UUID()
        self.name = name
        self.uid = uid
        self.createDate = Date()
    }
    
    func formattedDate() -> String? {
        if let date = dueDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/YY hh:mm"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    var isOverDue:Bool {
        if let due = dueDate {
            if due.timeIntervalSinceNow < 0 {
                return true
            }
        }
        return false
    }
    
}

