//
//  Category.swift
//  Todoey (with Realm)
//
//  Created by Dev on 7/22/24.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title = ""
    @objc dynamic var color: String?
    let todos = List<Todo>()
}
