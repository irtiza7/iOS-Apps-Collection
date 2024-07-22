//
//  DatabaseService.swift
//  Todoey (with Realm)
//
//  Created by Dev on 7/22/24.
//

import UIKit
import RealmSwift

class DatabaseService {
    
    // MARK: - Static Properties
    
    static let shared = DatabaseService()
    
    // MARK: - Private Properties
    
    private let realm = try! Realm()
    
    // MARK: - Initializers
    
    private init() {}
    
    // MARK: - Methods For Saving Records
    
    public func saveObject(object: Object) {
        do {
            try realm.write({
                realm.add(object)
            })
        }catch {
            print(error)
        }
    }
    
    public func saveTodo(_ todo: Todo, _ category: Category) {
        do {
            try realm.write({
                realm.add(todo)
                category.todos.append(todo)
            })
        } catch {
            print(error)
        }
    }
    
    // MARK: - Methods For Fetching Records
    
    public func fetchAllObjects<T: Object>(ofType: T.Type) -> Results<T> {
        realm.objects(ofType.self)
    }
    
    public func fetchTodos(againstCategory category: Category, sortBy: String = "dateCreated") -> Results<Todo> {
        category.todos.sorted(byKeyPath: sortBy, ascending: true)
    }
    
    // MARK: - Methods For Updating Records
    
    public func updateTodo(updateOperation: @autoclosure () -> ()) {
        do {
            try realm.write({
                updateOperation()
            })
        } catch {
            print(error)
        }
    }
    
    // MARK: - Methods For Deleting Records
    
    public func deleteObject(object: Object) {
        do {
            try realm.write({
                realm.delete(object)
            })
        } catch {
            print(error)
        }
    }
}

