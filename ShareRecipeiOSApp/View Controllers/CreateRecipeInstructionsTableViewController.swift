//
//  CreateRecipeInstructionsTableViewController.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/22/21.
//

import UIKit

class CreateRecipeInstructionsTableViewController: UITableViewController {

        
    // MARK: Properties
    var directions: [String] = [] {
        didSet {
            updateDirectionsList()
        }
    }
    
    // MARK: Initializers
    required init(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    init?(coder: NSCoder, directions: [String]) {
        self.directions = directions
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func addIngredient(_ sender: Any) {
        let alert = UIAlertController(title: "Recipe Directions",
                                      message: "Add directions to your recipe",
                                      preferredStyle: .alert)
        alert.view.tintColor = UIColor.orange
        
        let saveAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let textField = alert.textFields?.first, let text = textField.text else { return }
            
            self.directions.append(text)
 
        }
    
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
    
        alert.addTextField()
        
        alert.textFields?[0].autocapitalizationType = .sentences
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateDirectionsList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DirectionsCell")
        cell?.textLabel?.text = directions[indexPath.row]
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        directions.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

}
