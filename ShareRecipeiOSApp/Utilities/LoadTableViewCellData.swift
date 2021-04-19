//
//  LoadTableViewCellData.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 4/19/21.
//

import Foundation
import UIKit

@objc class LoadTableViewCellData: NSObject {
    let heartFillImage = UIImage(systemName: "heart.fill")
    let heartEmptyImage = UIImage(systemName: "heart")
    
    let recipes: [Recipe]
    let user: User?
    let tableView: UITableView
    
    init(recipes: [Recipe], user: User?, tableView: UITableView) {
        self.recipes = recipes
        self.user = user
        self.tableView = tableView
        let cellNib = UINib(nibName: "ShowRecipeTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "ShowRecipeTableViewCell")
    }

    func loadRecipeCell(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

}
