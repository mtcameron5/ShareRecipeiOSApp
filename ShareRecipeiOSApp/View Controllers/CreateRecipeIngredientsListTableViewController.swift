//
//  CreateRecipeIngredientsListTableViewController.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/21/21.
//

import UIKit

class CreateRecipeIngredientsListTableViewController: UITableViewController {
    
    // MARK: Properties
    var ingredients: [String] = [] {
        didSet {
            updateIngredientsList()
        }
    }
    
    // MARK: Initializers
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    init?(coder: NSCoder, ingredients: [String]) {
        self.ingredients = ingredients
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func addIngredient(_ sender: Any) {
        let alert = UIAlertController(title: "Recipe Item",
                                      message: "Add an item to your recipe",
                                      preferredStyle: .alert)
        alert.view.tintColor = UIColor.orange
        
        let saveAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let textField = alert.textFields?.first, let text = textField.text else { return }
            
            self.ingredients.append(text)
        }


        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
    
        alert.addTextField()
        
        alert.textFields?[0].autocapitalizationType = .sentences
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        

        
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateIngredientsList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        ingredients.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsCell")
        cell?.textLabel?.text = ingredients[indexPath.row]
        return cell!
    }

}
