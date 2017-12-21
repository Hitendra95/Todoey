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
    var itemArray = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = defaults.array(forKey: "TodoListArray") as? [String]
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
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    // MARK- delegate method of table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK- ADD new item button
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
 // what will happen if user click add item
        // print("succcefull!")
            self.itemArray.append(textField.text!)
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

