//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Gideon Ubaldo on 1/15/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 80
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if categories is not nil then return 1 instead
        return categories?.count ?? 1
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellforRowat")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    //this happens before segue happens
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if we have more than 2 sugues coming form it, then we have to check the destination first. the only reason that there is no filter is because we know that we only have one way of going there
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            print(categories?[indexPath.row])
        }
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category){
        print("size before save\(categories?.count)")
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving context \(error)")
        }
        
        //tableView reprints each cell again. this is going back to the tableView cellforrowat function
        print(print("size before save\(categories?.count)"))
        tableView.reloadData()
    }
    func loadCategories() {
        //this is where the auto loads happen from the realm to the array
        categories = realm.objects(Category.self)

        print("load")
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Create new Category"
        }
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Swipe Cell Delegate Method
extension CategoryViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        //this is when it gets deleted
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Item deleted")
            
            //since some of the variables here are global, we need to specify self in order to succint in what we're pertianing to since this is a closure
            if let category = self.categories?[indexPath.row] {
                do{
                    try self.realm.write {
                        self.realm.delete(category)
                    }
                }catch{
                    print("Error deleting category, \(error)")
                }
                //theres no need to reload since the editActionsOptionsForRowAt has been implement which do the deleting part
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
