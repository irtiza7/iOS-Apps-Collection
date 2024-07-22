//
//  TodoViewController.swift
//  Todoey (with Realm)
//
//  Created by Dev on 7/22/24.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class TodoListViewController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var todoSearchBar: UISearchBar!
    
    // MARK: - Private Properties
    
    private let databaseService: DatabaseService = DatabaseService.shared
    private var todos: Results<Todo>?
    
    // MARK: - Public Properties
    
    public var category: Category? {
        didSet {
            fetchTodosAgainstCategoryTitle()
        }
    }
    
    // MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoSearchBar.delegate = self
        fetchTodosAgainstCategoryTitle()
        tableView.rowHeight = 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navigationController = navigationController else {fatalError("Navigation Controller Doesnt Exist")}
        guard let colorHex = category?.color else {return}
        guard let color = UIColor(hexString: colorHex) else {return}
        
        navigationController.navigationBar.barTintColor = color
        navigationController.navigationBar.backgroundColor = color
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.accessibilityIgnoresInvertColors = false
        
        title = category?.title
    }
    
    // MARK: - IBActions
    
    @IBAction func addTodoPressed(_ sender: UIBarButtonItem) {
        var uiTextField = UITextField()
        
        let alertViewController = UIAlertController(title: "Add new todoey", message: "...", preferredStyle: .alert)
        alertViewController.addTextField { textField in
            uiTextField = textField
        }
        
        let alertAction = UIAlertAction(title: "Add", style: .default) { action in
            guard let todoTitle = uiTextField.text else {return}
            guard todoTitle != "" else {return}
            
            let newTodo = Todo()
            newTodo.title = todoTitle
            newTodo.dateCreated = Date()
            
            self.saveTodoIntoDB(newTodo)
            self.tableView.reloadData()
        }
        alertViewController.addAction(alertAction)
        present(alertViewController, animated: true)
    }
}

// MARK: - Data Model Manipulation Methods

extension TodoListViewController {
    private func saveTodoIntoDB(_ todo: Todo) {
        guard let category = category else {return}
        databaseService.saveTodo(todo, category)
    }
    
    private func fetchTodosAgainstCategoryTitle() {
        guard let category = category else {return}
        todos = databaseService.fetchTodos(againstCategory: category)
    }
    
    private func deleteTodoFromDB(forIndex index: Int) {
        guard let todos = self.todos else {return}
        let todoToDelete = todos[index]
        databaseService.deleteObject(object: todoToDelete)
    }
}

// MARK: - TableView Data Source Methods

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        if let todo = todos?[indexPath.row]  {
            cell.textLabel?.text = todo.title
            cell.accessoryType = todo.isDone ? .checkmark : .none
            
            if let colorHex = category?.color {
                let color = UIColor(hexString: colorHex)!
                let percentage = CGFloat(indexPath.row) / CGFloat(self.todos!.count)
                let modifiedColor = color.darken(byPercentage: percentage)!
                
                cell.backgroundColor = modifiedColor
                cell.textLabel?.textColor = ContrastColorOf(modifiedColor, returnFlat: true)
            }
        }else {
            cell.textLabel?.text = "No Todos"
            cell.selectionStyle = .none
        }
        return cell
    }
}

// MARK: - TableView Delegate Methods

extension TodoListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView.cellForRow(at: indexPath)?.selectionStyle == UITableViewCell.SelectionStyle.none) {
            return
        }
        guard let todo = todos?[indexPath.row] else {return}
        let updateTodoStatus = { todo.isDone = !todo.isDone } // autoclosure magic, swift is <3
        databaseService.updateTodo(updateOperation: updateTodoStatus())
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}

// MARK: - Search Bar Delegate Methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let title = searchBar.text else {return}
        todos = todos?.filter("title CONTAINS[cd] %@", title).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.todoSearchBar.showsCancelButton = true
        if(searchText.count == 0) {
            fetchTodosAgainstCategoryTitle()
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        todoSearchBar.showsCancelButton = false
        todoSearchBar.text = nil
        todoSearchBar.resignFirstResponder()
        
        fetchTodosAgainstCategoryTitle()
        tableView.reloadData()
    }
}

// MARK: - SwipeTableViewCell Delegate Methods

extension TodoListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteTodoFromDB(forIndex: indexPath.row)
        }
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}

