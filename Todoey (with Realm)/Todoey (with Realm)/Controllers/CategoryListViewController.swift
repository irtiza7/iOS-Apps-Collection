//
//  CategoryViewController.swift
//  Todoey (with Realm)
//
//  Created by Dev on 7/22/24.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryListViewController: UITableViewController {
    
    // MARK: - Private Properties
    
    private let databaseService = DatabaseService.shared
    private var categories: Results<Category>?
    
    // MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAllCategoriesFromDB()
        tableView.rowHeight = 70
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let navigationController = navigationController else {fatalError("Navigation Controller Doesnt Exist")}
        navigationController.navigationBar.barTintColor = UIColor(hexString: "DFC91B")
        navigationController.navigationBar.backgroundColor = UIColor(hexString: "DFC91B")
    }
    
    // MARK: - IBActions
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        var uiTextField = UITextField()
        
        let alertVC: UIAlertController = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        alertVC.addTextField() { textField in
            uiTextField = textField
        }
        
        let alertAction: UIAlertAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            guard let categoryTitle = uiTextField.text else {return}
            guard categoryTitle != "" else {return}
            
            let newCategory = Category()
            newCategory.title = categoryTitle
            newCategory.color = UIColor(randomFlatColorOf: .dark).hexValue()
            
            self.saveCategoryIntoDB(category: newCategory)
            self.tableView.reloadData()
        }
        
        alertVC.addAction(alertAction)
        present(alertVC, animated: true)
    }
}

// MARK: - Data Model Manipulation Methods

extension CategoryListViewController {
    private func saveCategoryIntoDB(category: Category) {
        databaseService.saveObject(object: category)
    }
    
    private func fetchAllCategoriesFromDB() {
        categories = databaseService.fetchAllObjects(ofType: Category.self)
    }
    
    private func deleteCategoryFromDB(forIndex index: Int) {
        guard let categories = self.categories else {return}
        let categoryToDelete = categories[index]
        self.databaseService.deleteObject(object: categoryToDelete)
    }
}

// MARK: - TableView Data Source Methods

extension CategoryListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.title
            
            if let colorHex = category.color {
                let color = UIColor(hexString: colorHex)!
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No Categories"
            cell.selectionStyle = .none
        }
        return cell
    }
}

// MARK: - TableView Delegate Methods

extension CategoryListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath)?.selectionStyle != UITableViewCell.SelectionStyle.none else {return}
        performSegue(withIdentifier: "goToTodos", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListViewController
        guard let selectedRowIndexPath = self.tableView.indexPathForSelectedRow else {return}
        destVC.category = self.categories?[selectedRowIndexPath.row]
    }
}

// MARK: - SwipeTableViewCell Delegate Methods

extension CategoryListViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteCategoryFromDB(forIndex: indexPath.row)
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

