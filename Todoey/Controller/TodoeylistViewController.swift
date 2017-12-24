//
//  ViewController.swift
//  Todoey
//
//  Created by Hitendra Dubey on 12/21/17.
//  Copyright © 2017 Hitendra Dubey. All rights reserved.
//

import UIKit
import CoreData

class TodoeylistViewController: UITableViewController {

 //   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        //let newItem = Item()  //codeable type code
        //Core data code
        
        loadItems()

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
          
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
          self.saveItem()
        }
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "create new item"
           // print(alertTextField.text)
            textField = alertTextField
        }
        alert.addAction(action)
            present(alert, animated: true, completion: nil)
    
    }
    func saveItem()
    {
       // let encoder = PropertyListEncoder()
        do{
            //codeable code
            //let data = try encoder.encode(itemArray)
            //try data.write(to: dataFilePath!)
            try context.save()
        }
        catch
        {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    
    }
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest())

    {
//        if let data = try? Data(contentsOf: dataFilePath!)
//
//        {
//            let decoder = PropertyListDecoder()
//            do
//            {
//                itemArray = try decoder.decode([Item].self, from: data)
//            }
//            catch
//            {
//                print(error)
//            }
//        }
       
        do
        {
           itemArray =  try context.fetch(request)
        }
        catch
        {
            print("error in fetching data \(error)")
        }
        tableView.reloadData()
    }
    
}
extension TodoeylistViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0
        {
            loadItems()
            DispatchQueue.main.async
            {
                searchBar.resignFirstResponder()
            }
            
        }
        
    }
}
