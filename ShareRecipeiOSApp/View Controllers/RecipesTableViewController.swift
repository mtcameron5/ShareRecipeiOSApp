//
//  RecipesTableViewController.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/16/21.
//

import UIKit

class RecipesTableViewController: BaseTableViewController {
    
    // MARK: - Properties
    var recipes: [Recipe] = []
    var recipeLikes: Int = 0
    var recipesRequest = ResourceRequest<Recipe>(resourcePath: "recipes")
    var user: User?
    let userRequest = UserRequest()
    let heartFillImage = UIImage(systemName: "heart.fill")
    let heartEmptyImage = UIImage(systemName: "heart")
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "ShowRecipeTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ShowRecipeTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh(nil)
        
        if let authToken = Auth().token {
            userRequest.getUser(tokenID: authToken) { [weak self] result in
                switch result {
                case .failure:
                    print("need to make the save buttons disabled")
                    
                case .success(let foundUser):
                    self?.user = foundUser
                }
            }
        } else {
            self.user = nil
        }
    }
    
    // MARK: - Navigation
    @IBSegueAction func makeRecipeDetailTableViewController(_ coder: NSCoder) -> RecipesDetailTableViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowRecipeTableViewCell", for: indexPath) as! ShowRecipeTableViewCell
        let recipe = recipes[indexPath.row]
        cell.recipe = recipe
        let recipeRequest = RecipeRequest(recipeID: recipe.id!)
        
        // Add tag and target to button to identify which recipe button is being selected
        cell.saveButton.tag = indexPath.row
        cell.saveButton.addTarget(self, action: #selector(saveButtonClicked(sender:)), for: .touchUpInside)
        
        // Check if the user likes the recipe, if user does, fill recipe with heart shape
        if let user = user {
            let userRequest = UserRequest()
            userRequest.getLikedRecipes(userID: user.id!) { [self] result in
                switch result {
                case .success(let recipes):
                    let userLikesRecipe = doesUserLikeRecipe(recipes: recipes, targetRecipe: recipe)
                    if userLikesRecipe {
                        DispatchQueue.main.async {
                            cell.saveButton.setImage(heartFillImage, for: .normal)
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.saveButton.setImage(heartEmptyImage, for: .normal)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            cell.saveButton.isEnabled = false
        }

        recipeRequest.getNumberOfLikes { result in
            switch result {
            case .success(let recipeLikes):
                DispatchQueue.main.async {
                    if recipeLikes == 1 {
                        cell.recipeLikesLabel.text = "1 Save"
                    } else {
                        cell.recipeLikesLabel.text = "\(recipeLikes) Saves"
                    }
                }
            case .failure:
                cell.recipeLikesLabel.text = "0 Saves"
            }
        }
        
        cell.recipeNameLabel.text = recipe.name
        return cell
    }
    
    @objc func saveButtonClicked(sender: UIButton) {
        let recipe = recipes[sender.tag]
        let recipeRequest = RecipeRequest(recipeID: recipe.id!)
        
//        let image = sender.image(for: .normal)
//        if let image = image {
//            if heartEmptyImage == image {
//                print("heartFillImage is set")
//                sender.setImage(heartFillImage, for: .normal)
//            } else {
//                print("heartEmptyImage is set")
//                sender.setImage(heartEmptyImage, for: .normal)
//            }
//        }
        // If user exists, then allow liking of recipe, otherwise we should disable the button
        if let user = user {
            // likeRecipeRequest
            if sender.image(for: .normal) == heartEmptyImage {
                recipeRequest.userLikesRecipe(userID: user.id!, recipeID: recipe.id!, token: Auth().token!) { result in
                    switch result {
                    case .success(let statusCode):
                        print(statusCode)
                        DispatchQueue.main.async {
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            // unlikeRecipeRequest
            } else {
                recipeRequest.userUnlikesRecipe(userID: user.id!, recipeID: recipe.id!, token: Auth().token!) { result in
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        
        
        

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let recipe = recipes[indexPath.row]
        
        performSegue(withIdentifier: "RecipesToRecipeDetail", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        if let recipeID = recipe.id {
            recipesRequest.delete(id: recipeID)
        }
        recipes.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }

}

func doesUserLikeRecipe(recipes: [Recipe], targetRecipe: Recipe) -> Bool {
    for recipe in recipes {
        if recipe.id == targetRecipe.id {
            return true
        }
    }
    return false
}
