//
//  ViewController.swift
//  Todoey
//
//  Created by Baryskhan Bimat on 27.08.2018.
//  Copyright © 2018 Baryskhan Bimat. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK Add New Items 
    @IBAction func addButtomPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default){(action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding itemArray \(error)")
        }
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                try itemArray = decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding itemArray \(error)")
            }
        }
    }
}

