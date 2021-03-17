//
//  RecipesDetailTableViewController.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/17/21.
//

import UIKit

class RecipesDetailTableViewController: UITableViewController {
    // MARK: - Properties
    var recipe: Recipe {
        didSet {
            updateRecipeView()
        }
    }
    
    var user: User? {
        didSet {
            updateRecipeView()
        }
    }
    
    // MARK: - Initializers
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    init?(coder: NSCoder, recipe: Recipe) {
        self.recipe = recipe
        super.init(coder: coder)
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecipeData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRecipeData()
    }
    
    // MARK: - Model Loading
    func getRecipeData() {
        guard let id = recipe.id else {
            return
        }
        
        let recipeDetailRequest = RecipeRequest(recipeID: id)
        recipeDetailRequest.getUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
            case .failure:
                let message = "There was an error getting the recipe's user"
                ErrorPresenter.showError(message: message, on: self)
            }
        }
    }
    
    func updateRecipeView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditRecipeSegue" {
            guard let destination = segue.destination as? CreateRecipeTableViewController else {
                return
            }
            destination.selectedUser = user
            destination.recipe = recipe
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
