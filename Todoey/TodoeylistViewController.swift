//
//  ViewController.swift
//  Todoey
//
//  Created by Hitendra Dubey on 12/21/17.
//  Copyright © 2017 Hitendra Dubey. All rights reserved.
//

import UIKit

class TodoeylistViewController: UITableViewController {

    let itemArray = ["hiten","bhai","maa"]
    override func viewDidLoad() {
        super.viewDidLoad()
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

}

