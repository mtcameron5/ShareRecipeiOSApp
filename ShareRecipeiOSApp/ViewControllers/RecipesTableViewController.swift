//
//  RecipesTableViewController.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/16/21.
//

import UIKit

class RecipesTableViewController: UITableViewController {
    
    // MARK: - Properties
    var recipes: [Recipe] = []
    let recipesRequest = ResourceRequest<Recipe>(resourcePath: "recipes")
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "ShowRecipeCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ShowRecipeCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh(nil)
    }
    
    // MARK: - Navigation
    @IBSegueAction func makeRecipeDetailTableViewController(_ coder: NSCoder) -> RecipesDetailTableViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            print("error")
            return nil
        }
        let recipe = recipes[indexPath.row]
        return RecipesDetailTableViewController(coder: coder, recipe: recipe)
    }
    
    // MARK: - IBActions
    @IBAction func refresh(_ sender: UIRefreshControl?) {
        recipesRequest.getAll { [weak self] result in
            
            DispatchQueue.main.async {
                sender?.endRefreshing()
            }
          
            switch result {
            case .failure:
                ErrorPresenter.showError(message: "There was a problem getting the recipes", on: self)
            case .success(let recipes):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.recipes = recipes
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowRecipeCell", for: indexPath) as! ShowRecipeCell
        let recipe = recipes[indexPath.row]
        cell.recipeNameLabel.text = recipe.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RecipesToRecipeDetail", sender: nil)
    }

}
