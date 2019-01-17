//
//  ViewController.swift
//  Todoey
//
//  Created by Gideon Ubaldo on 1/12/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //loadItems function would be loaded up as soon as selectedCategory runs
    var selectedCategory : Category? {
        didSet{
            loadItems()
            print("didSet")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none

        //the locaiton of the data in computer
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //this will be called before view Did Load.
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            
            title = selectedCategory!.name
            
            //this is for the programmer to see
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist...")}
            
            if let navBarColor = UIColor(hexString: colorHex){
            
            navBar.barTintColor = navBarColor
                
            navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
            
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
                
            searchBar.barTintColor = navBarColor
            }
        }
    }
    
    
    // the number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //this is to draw the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("draw cell")
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]  {
        
        cell.textLabel?.text = item.title
        
        //we can force unwrapped the todoItems since at this point we know that todoItems is not empty because its within if let optional binding
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:(CGFloat(indexPath.row) / (CGFloat(todoItems!.count)))){
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
            
        //indexPath always start with index 0
        //whole number divided by whole number = whole number, for our reason, the second version is more needed
//        print("Version 1: \(CGFloat(indexPath.row / todoItems!.count))")
        
        //float divided float = float
//        print("Version 2: \(CGFloat(indexPath.row) / (CGFloat(todoItems!.count)))")
        
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        saveItems()
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write{
                    item.done = !item.done
                }
            }catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        //this is to deselect the item after being highligted
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //pragma mark
    
    //MARK: - Add New Items
    @IBAction func addBUttonPressed(_ sender: UIBarButtonItem){
        
        var textField = UITextField()
        
        //both alert and action are in the same modal. one is the mesage with title and another with the button action
        
        //this is to alert pop up
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        
        let action  = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clocks the Add item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
                do{//realm.write is the commiting
                    try self.realm.write{
                        //inside is a staging area
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        //this is binding the action to the alert message
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        //this is actually the thing that makes it show
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do{
            try realm.write {
                realm.delete(item)
                }
            }
            catch{
                ("Error deleting cell, \(error)")
            }
        }
    }
}

//MARK: - Search bar methods
//this is to modular the delegation and functionality
//the delegation has been made through connection from the main story board. and so we know which "searchBar" this one is pertaining to
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            //this is for memory management... this 2 blocks of code remove the cursor from the searchbar.dispathcqueue is mainly so that it could be done quick.
            //note that there is only one main thread. the one that works most efficiently. Dispatch queue is the manager. main is the main thread.
            DispatchQueue.main.async {
                //dismiss keyboard and remove the cursor from the searchbar
                searchBar.resignFirstResponder()
            }
        }
    }
}

