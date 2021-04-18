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
//        navigationController?.navigationBar.prefersLargeTitles = false
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
    
    // MARK: - IBActions
    @IBAction func updateRecipeDetails(_ segue: UIStoryboardSegue) {
        guard let controller = segue.source as? CreateRecipeTableViewController else {
            return
        }
        user = controller.selectedUser
        if let recipe = controller.recipe {
            self.recipe = recipe
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return recipe.ingredients.count
        } else if section == 2 {
            return recipe.directions.count
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDetailCell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = recipe.name
        case 1:
            cell.textLabel?.text = recipe.ingredients[indexPath.row]
        case 2:
            cell.textLabel?.text = recipe.directions[indexPath.row]
        case 3:
            cell.textLabel?.text = "\(recipe.servings)"
        case 4:
            cell.textLabel?.text = recipe.prepTime
        case 5:
            cell.textLabel?.text = recipe.cookTime
        case 6:
            cell.textLabel?.text = user?.username // ?? ""
        default:
            break
        }
        
//        if indexPath.section == 4 {
//            cell.selectionStyle = .default
//            cell.isUserInteractionEnabled = true
//        } else {
//            cell.selectionStyle = .none
//            cell.isUserInteractionEnabled = false
//        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Recipe"
        case 1:
            return "Recipe Ingredients"
        case 2:
            return "Recipe Directions"
        case 3:
            return "Recipe Servings"
        case 4:
            return "Recipe Prep Time"
        case 5:
            return "Recipe Cook Time"
        case 6:
            return "Created By"
        default:
            return nil
        }
    }

}
