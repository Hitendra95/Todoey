//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hitendra Dubey on 12/25/17.
//  Copyright © 2017 Hitendra Dubey. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    //initilizing new realm
    let realm = try! Realm()
    var categoryArrays : Results<Category>?
    //var categoryArrays = [Category]() coredata code
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext core data code
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategorie()
        
       
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
            
            //let newCategory = Category(context: self.context)     core Data code
            let newCategory = Category()  //realm code
            newCategory.name = textField.text!
         //   self.categoryArrays.append(newCategory)
            //self.saveCategory() core data code
            self.save(category: newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new Category"
        }
        present(alert, animated: true, completion: nil)
    }
        //func saveCategory()  coreData code
    func save(category : Category)
        {
            do
            {
                //try context.save()   coredata code
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
 //       core data codes
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do
//        {
//            categoryArrays = try context.fetch(request)
//        }
//        catch
//        {
//            print("eror in fetching data\(error)")
//        }
        
        
        //realm code
        categoryArrays = realm.objects(Category.self)
        tableView.reloadData()
        
    }
        
        
}



