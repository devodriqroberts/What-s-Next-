//
//  MainTableViewController.swift
//  What's Next?
//
//  Created by Devodriq Roberts on 7/14/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Study Firebase", "Study Alamofire"]

    override func viewDidLoad() {
        super.viewDidLoad()


    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Add checkmark functionality to list table view
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new item
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Next Up Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            guard let textFieldText = textField.text else {return}
            self.itemArray.append(textFieldText)
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "Create new item"
            textField = alertTextFeild
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
   

   

}
