//
//  ViewController.swift
//  Todoey
//
//  Created by Hitendra Dubey on 12/21/17.
//  Copyright © 2017 Hitendra Dubey. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class TodoeylistViewController: UITableViewController {

 //   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet {
            loadItems()
            
        }
    }
    //var itemArray = [Item]() core data
     //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext core data code
    
    var todoItems : Results<Item>?
    override func viewDidLoad() {
        super.viewDidLoad()
        //let newItem = Item()  //codeable type code
        //Core data code
        
        //loadItems()

    }
  // MARK- Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemcell", for:indexPath )
        if let item = todoItems?[indexPath.row]
        {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else
        {
            cell.textLabel?.text = "No Item Added"
            
        }
//        cell.textLabel?.text = todoItems?[indexPath.row].title
//        if todoItems[indexPath.row].done == true
//        {
//            cell.accessoryType = .checkmark
//        }
//        else
//        {
//            cell.accessoryType = .none
//        }
//
        
        return cell
    }
    // MARK- delegate method of table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]
        {
            do
            {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch
            {
                print("error in updating items\(error)")
            }
        }
        
//        if todoItems[indexPath.row].done == false
//        {
//            todoItems[indexPath.row].done = true
//        }
//        else
//        {
//            todoItems[indexPath.row].done = false
//        }
        
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
          if let currentCategor = self.selectedCategory
          {
            do{
            try self.realm.write {
             let newItem = Item()
               newItem.title = textField.text!
                newItem.dateOfCreation = Date()
            currentCategor.items.append(newItem)
                 self.tableView.reloadData()            }
        }
            catch{
                print("error in saving items\(error)")
            }
        }
           
    }
    tableView.reloadData()
            
            
            //newItem.done = false
           // newItem.parentCategory = self.selectedCategory
            //self.itemArray.append(newItem)
         
         // self.saveItem()
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "create new item"
           // print(alertTextField.text)
            textField = alertTextField
        }
        alert.addAction(action)
            present(alert, animated: true, completion: nil)
    
}
//    func saveItem()
//    {
//       // let encoder = PropertyListEncoder()
//        do{
//            //codeable code
//            //let data = try encoder.encode(itemArray)
//            //try data.write(to: dataFilePath!)
//            try context.save()
//        }
//        catch
//        {
//            print("Error saving context \(error)")
//        }
//        self.tableView.reloadData()
//
//    }
   // func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) core data
    func loadItems()
    {
// core data code
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate , predicate])
//        request.predicate = compoundPredicate
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
       
//        do
//        {
//           itemArray =  try context.fetch(request)
//        }
//        catch
//        {
//            print("error in fetching data \(error)")
//        }
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
   }
    
}
extension TodoeylistViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateOfCreation", ascending: true)
        
        tableView.reloadData()

//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.predicate = predicate
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//        loadItems(with: request , predicate: predicate)
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

