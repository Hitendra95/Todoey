//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hitendra Dubey on 12/25/17.
//  Copyright © 2017 Hitendra Dubey. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    var categoryArrays = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategorie()
        
       
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArrays.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Categorycell", for: indexPath)
        
        cell.textLabel?.text = categoryArrays[indexPath.row].name
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeylistViewController
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categoryArrays[indexPath.row]
        }
    }

    @IBAction func addButtonpressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArrays.append(newCategory)
            self.saveCategory()
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new Category"
        }
        present(alert, animated: true, completion: nil)
    }
        func saveCategory()
        {
            do
            {
                try context.save()
            }
            catch
            {
                print("Error saving context\(error)")
                
                
            }
            self.tableView.reloadData()
        }
    
    func loadCategorie()
    {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do
        {
            categoryArrays = try context.fetch(request)
        }
        catch
        {
            print("eror in fetching data\(error)")
        }
        tableView.reloadData()
        
    }
        
        
}



