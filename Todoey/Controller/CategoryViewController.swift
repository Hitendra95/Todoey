//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hitendra Dubey on 12/25/17.
//  Copyright © 2017 Hitendra Dubey. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    //initilizing the realm
    let realm = try! Realm()
    var categoryArrays : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategorie()

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArrays?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Categorycell", for: indexPath)
        
        cell.textLabel?.text = categoryArrays?[indexPath.row].name ?? "No Categories Added Here"
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeylistViewController
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categoryArrays?[indexPath.row]
        }
    }

    @IBAction func addButtonpressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new Category"
        }
        present(alert, animated: true, completion: nil)
    }
    
    func save(category : Category)
        {
            do
            {
                try realm.write {
                    realm.add(category)
                    
                }
            }
            catch
            {
                print("Error saving context\(error)")
                
                
            }
            self.tableView.reloadData()
        }
    
    func loadCategorie()
    {

        categoryArrays = realm.objects(Category.self)
        tableView.reloadData()
        
    }
        
        
}



