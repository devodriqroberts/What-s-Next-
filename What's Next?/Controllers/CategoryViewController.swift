//
//  CategoryViewController.swift
//  What's Next?
//
//  Created by Devodriq Roberts on 7/15/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    //1.create variable with instance of category array entity
    var categoryArray = [Category]()
    
    //2.create constant for coredata viewContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    
    
    // MARK: - 3.Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MainTableViewController
        
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        destinationVC.selectedCategory = categoryArray[indexPath.row]
    }
    
    
    //MARK: - 4.Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //create textField instance
        var categoryTextField = UITextField()
        
        // create an alert w/ text field for adding categories
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            guard let textFieldText = categoryTextField.text else {return}
            
            //Create new category entity
            let newCategory = Category(context: self.context)
            newCategory.name = textFieldText
            
            //Add new categories to Category entity
            self.categoryArray.append(newCategory)
            
            //Saves newly created Category to CoreData context
            self.saveCategory()
        }
        
        //Add text field
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            categoryTextField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Data Manipulation Methods
    
    //Method call to save changes to core data context
    func saveCategory() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category to context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Load from context Method
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate Methods

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadCategories(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadCategories()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

















