//
//  Task.swift
//  Motive
//
//  Created by Aedan Joyce on 7/18/17.
//  Copyright © 2017 Aedan Joyce. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var isCompleted = false
    @objc dynamic var dueDate = ""
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
class DueDate: Object {
    @objc dynamic var name = ""
    @objc dynamic var dueDate = ""
    @objc dynamic var dateID = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "dateID"
    }
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}

class TaskList: Object {
    @objc dynamic var name = ""
    let tasks = List<Task>()
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}
