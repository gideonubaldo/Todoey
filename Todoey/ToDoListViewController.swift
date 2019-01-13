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
    
    var itemArray = ["Say hello", "exercise"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // var itemArray = defaults.array(forKey: "ToDoListArray") as! [String]
        //the problem about the statement above is that our application would crash if the array didn't have anything. and so we do the checks below. we do optional binding
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [String]{
            itemArray = items
        }
    }
    
    // the number of rows in the table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //indexpath is consisted of a lot of things so you have to specify which one are you pertaining to.
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        //this is so that we put an accessory after tapping to the selected cell and removing it if does have something
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
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
            self.itemArray.append(textField.text!)
            
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

