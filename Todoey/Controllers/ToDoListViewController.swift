//
//  ViewController.swift
//  Todoey
//
//  Created by Gideon Ubaldo on 1/12/19.
//  Copyright © 2019 Gideon Ubaldo. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    //this is for the database
//    let defaults = UserDefaults.standard
    
    //looking for the documentdirectory in the userdomainmask
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
//    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray = [Item]()
    
    //loadItems function would be loaded up as soon as selectedCategory runs
    var selectedCategory : Category? {
        didSet{
            loadItems()
            print("didSet")
        }
    }
    
    //container/database management
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //in order to delagate the info, you must declare it first say an IBOutlet
//        searchBar.delegate = self
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
//            itemArray = items
//        }
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
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        
//        //this would just delete it in the context.
//        context.delete(itemArray[indexPath.row])
//
//        //this would just remove the item in the table array which is used to load them up
//        itemArray.remove(at: indexPath.row)
        
        
            // code below would work if I want a particular cell to be deleted
//        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        //this only reflects on the array and not in the database so far. the following code below flips the current property of done
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
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
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
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
    
    func saveItems(){
        //this is writing it into a plist but not in the userdefault but into the Filemanager. this works because we encode the customize class; this wont work if it was in the user default.standard
        do{
           try context.save()
        }catch{
            print("Error saving context \(error)")
        }
         self.tableView.reloadData()
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            //try and fectch the request and then assign it to the itemArray
        itemArray = try context.fetch(request)
        } catch {
            print("Error fetching from context \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search bar methods
//this is to modular the delegation and functionality
//the delegation has been made through connection from the main story board. and so we know which "searchBar" this one is pertaining to
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
       
        //query language;NSPredicate. the searchBar.text! would then be put in the %@ placeholder. the cd means its case and diacritic insentitive. diacritic is the letter with different symbols to complete them
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //since the descriptor could take multiple descriptor, and could be put into the array. in our case, we only care about the title
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        //this is the fetching itself
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
//            this is for memory management... this 2 blocks of code remove the cursor from the searchbar.dispathcqueue is mainly so that it could be done quick.
            //note that there is only one main thread. the one that works most efficiently. Dispatch queue is the manager. main is the main thread.
            DispatchQueue.main.async {
                 //dismiss keyboard and remove the cursor from the searchbar
                searchBar.resignFirstResponder()
            }
        }
        
    }
}

