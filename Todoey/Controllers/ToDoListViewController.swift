//
//  ViewController.swift
//  Todoey
//
//  Created by Gideon Ubaldo on 1/12/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    //this is for the database
    let defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Say hello"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem.title = "excercise"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem.title = "shop"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
            itemArray = items
        }
    }
    
    // the number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //this is to draw the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("draw cell")
        
        
        //this would still work but as soon as this cell gets out of the screen, it would be destroyed and would be created as a new cell soon as it in the screen
//        let cell = UITableViewCell(style: .default , reuseIdentifier: "ToDoItemCell")
        
        //cell gets reused for the other cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        //indexpath is consisted of a lot of things so you have to specify which one are you pertaining to.
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //this is to reload data
        tableView.reloadData()
        //this is so that we put an accessory after tapping to the selected cell and removing it if does have something
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        //this is to deselect the item after being highligted
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //pragma mark
    
    //MARK - Add New Items
    @IBAction func addBUttonPressed(_ sender: UIBarButtonItem){
        
        var textField = UITextField()
        
        //both alert and action are in the same modal. one is the mesage with title and another with the button action
        
        //this is to alert pop up
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        
        let action  = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clocks the Add item button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.setValue(self.itemArray, forKey: "ToDoListArray")
            
            //after this we have to reload the whole table
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
    
    
}

