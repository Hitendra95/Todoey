//
//  ViewController.swift
//  Todoey
//
//  Created by Hitendra Dubey on 12/21/17.
//  Copyright © 2017 Hitendra Dubey. All rights reserved.
//

import UIKit

class TodoeylistViewController: UITableViewController {

    let defaults = UserDefaults.standard
    var itemArray = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let newItem = Item()
        itemArray.append(newItem)
        if let item = defaults.array(forKey: "TodoListArray") as? [Item]
        {
            itemArray = item
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

  // MARK- Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemcell", for:indexPath )
        cell.textLabel?.text = itemArray[indexPath.row].title
        if itemArray[indexPath.row].done == true
        {
            cell.accessoryType = .checkmark
        }
        else
        {
            cell.accessoryType = .none
        }
        return cell
    }
    // MARK- delegate method of table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if itemArray[indexPath.row].done == false
        {
            itemArray[indexPath.row].done = true
        }
        else
        {
            itemArray[indexPath.row].done = false
        }
        
       tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK- ADD new item button
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
 // what will happen if user click add item
        // print("succcefull!")
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "create new item"
           // print(alertTextField.text)
            textField = alertTextField
        }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            
        
        
        
    }
    
}

