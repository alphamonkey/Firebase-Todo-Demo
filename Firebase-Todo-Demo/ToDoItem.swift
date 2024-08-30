//
//  ToDoItem.swift
//  Firebase-Todo-Demo
//
//  Created by Josh Edson on 8/29/24.
//

import Foundation

struct ToDoItem:Codable, Identifiable {
    
    let guid:UUID
    var id:UUID {
        return guid;
    }
    let uid:String
    let name:String
    let dueDate:Date?
    let description:String?
    let priority:Int?
    init(uid:String, name:String, dueDate:Date?, description:String?, priority:Int?) {
        self.guid = UUID()
        self.uid = uid
        self.name = name
        self.dueDate = dueDate
        self.description = description
        self.priority = priority
    }
}

