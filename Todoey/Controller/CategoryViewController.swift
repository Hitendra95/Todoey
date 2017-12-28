//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hitendra Dubey on 12/25/17.
//  Copyright © 2017 Hitendra Dubey. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeViewController{
    //initilizing the realm
    let realm = try! Realm()
    var categoryArrays : Results<Category>?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadCategorie()
       

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArrays?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categoryArrays?[indexPath.row]
        {
            cell.textLabel?.text = category.name
            guard let categoryColour = UIColor(hexString : category.colour) else {fatalError()}
                cell.backgroundColor = categoryColour
                cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
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
            newCategory.colour = UIColor.randomFlat.hexValue()
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
    override func updateModel(at indexPath: IndexPath) {
         if let categoryForDelete = self.categoryArrays?[indexPath.row]
         {
        
        
                    do{
                        try self.realm.write
                        {
                            self.realm.delete(categoryForDelete)
        
                        }
                        }
                        catch{
                            print("error in deleting row\(error)")
                            }
        
                }
        
    }
        
        
}



