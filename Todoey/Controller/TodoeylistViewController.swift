//
//  ViewController.swift
//  Todoey
//
//  Created by Hitendra Dubey on 12/21/17.
//  Copyright © 2017 Hitendra Dubey. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoeylistViewController: SwipeViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet {
            loadItems()
            
        }
    }
 
    var todoItems : Results<Item>?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
   

    }
    override func viewWillAppear(_ animated: Bool)
    {
        guard let hexColour = selectedCategory?.colour else{fatalError()}
        title = selectedCategory?.name
        updateNavBar(withHexcode: hexColour)
        
    }
    override func viewWillDisappear(_ animated: Bool)
    {
       
        updateNavBar(withHexcode: "00FA92")
    }
    
    func updateNavBar(withHexcode colourHexCode : String)
    {
        guard let hexColour = selectedCategory?.colour else{fatalError()}
        
        
        guard let navbar = navigationController?.navigationBar else {fatalError("navigation controller is nil at this point")}
        guard let navBarColour = UIColor(hexString : hexColour) else{fatalError()}
        navbar.barTintColor = navBarColour
        searchBar.barTintColor = navBarColour
        navbar.tintColor = ContrastColorOf(navBarColour ,returnFlat: true)
        navbar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
    }
    
  // MARK- Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row]
        {
            cell.textLabel?.text = item.title
            if let colour = UIColor(hexString : selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count))
            {
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
            }
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else
        {
            cell.textLabel?.text = "No Item Added"
            
        }

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
        

       tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK- ADD new item button
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
 // what will happen if user click add item
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
    alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        alert.addAction(action)
            present(alert, animated: true, completion: nil)
    
}

    func loadItems()
    {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
   }
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDelete = self.todoItems?[indexPath.row]
        {
            do{
                try self.realm.write
                {
                    self.realm.delete(itemForDelete)
                    
                }
            }
            catch{
                print("error in deleting row\(error)")
            }
            
        }
    }
    
}
extension TodoeylistViewController : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateOfCreation", ascending: true)
        
        tableView.reloadData()


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

