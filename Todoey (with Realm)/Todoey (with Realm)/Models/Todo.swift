//
//  Todo.swift
//  Todoey (with Realm)
//
//  Created by Dev on 7/22/24.
//

import Foundation

import Foundation
import RealmSwift

class Todo: Object {
    @objc dynamic var title = ""
    @objc dynamic var isDone = false
    @objc dynamic var dateCreated: Date?
    var category = LinkingObjects(fromType: Category.self, property: "todos")
}
