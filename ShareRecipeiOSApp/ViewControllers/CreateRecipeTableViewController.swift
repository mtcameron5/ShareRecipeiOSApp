//
//  CreateRecipeTableViewController.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/17/21.
//

import UIKit

class CreateRecipeTableViewController: UITableViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var recipeIngredients: UITextField!
    @IBOutlet weak var recipeInstructions: UITextField!
    @IBOutlet weak var recipeServings: UITextField!
    @IBOutlet weak var recipeCookTime: UITextField!
    @IBOutlet weak var recipePrepTime: UITextField!
    @IBOutlet weak var createdByUsername: UITextField!
    
    
    // MARK: - Properties
    var selectedUser: User?
    var recipe: Recipe?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeName.becomeFirstResponder()
        if let recipe = recipe {
            recipeName.text = recipe.name
            recipeServings.text = "\(recipe.servings)"
            recipeCookTime.text = recipe.cookTime
            recipePrepTime.text = recipe.prepTime
            createdByUsername.text = selectedUser?.name
            navigationItem.title = "Edit Recipe"
        } else {
            populateUser()
        }
    }
    
    // MARK: - Load Data
    func populateUser() {
        let usersRequest = ResourceRequest<User>(resourcePath: "users")
        usersRequest.getAll { [weak self] result in
            switch result {
            case .failure:
                let message = "There was an error getting the users"
                ErrorPresenter.showError(message: message, on: self) { _ in
                    self?.navigationController?.popViewController(animated: true)
                }
            case .success(let users):
                DispatchQueue.main.async { [weak self] in
                    self?.createdByUsername.text = users[0].username
                }
                self?.selectedUser = users[0]
            }
        }
    }
    
    // MARK: - Navigation
    @IBSegueAction func makeSelectUserViewController(_ coder: NSCoder) -> SelectUserTableViewController? {
        guard let user = selectedUser else {
            return nil
        }
        return SelectUserTableViewController(coder: coder, selectedUser: user)
    }
    
    // MARK: - IBActions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveToDatabase(_ sender: UIBarButtonItem) {
        
        guard let recipeNameText = recipeName.text, !recipeNameText.isEmpty else {
            let message = "You must give a recipe name!"
            ErrorPresenter.showError(message: message, on: self)
            return
        }
        
        guard let recipeIngredientsText = recipeIngredients.text, !recipeIngredientsText.isEmpty else {
            let message = "You must specify the ingredients of the recipe"
            ErrorPresenter.showError(message: message, on: self)
            return
        }
        
        guard let recipeDirectionsText = recipeInstructions.text, !recipeDirectionsText.isEmpty else {
            let message = "You must specify the directions of the recipe"
            ErrorPresenter.showError(message: message, on: self)
            return
        }
        
        guard let recipeServingsText = recipeServings.text, !recipeServingsText.isEmpty else {
            let message = "You must specify the servings of the recipe"
            ErrorPresenter.showError(message: message, on: self)
            return
        }
        
        guard let recipeServingsInt = Int(recipeServingsText) else {
            let message = "You must only give a number"
            ErrorPresenter.showError(message: message, on: self)
            return
        }
        
        guard let recipePrepTimeText = recipePrepTime.text, !recipePrepTimeText.isEmpty else {
            let message = "You must specify the time to prepare the recipe"
            ErrorPresenter.showError(message: message, on: self)
            return
        }
        
        guard let recipeCookTimeText = recipeCookTime.text, !recipeCookTimeText.isEmpty else {
            let message = "You must specify the time to cook the recipe"
            ErrorPresenter.showError(message: message, on: self)
            return
        }
        
        guard let userID = selectedUser?.id else {
            let message = "You must have a user to create a recipe"
            ErrorPresenter.showError(message: message, on: self)
            return
        }
        
        
        let recipe = Recipe(userID: userID, name: recipeNameText, ingredients: [recipeIngredientsText], directions: [recipeDirectionsText], servings: recipeServingsInt, cookTime: recipeCookTimeText, prepTime: recipePrepTimeText)
        let recipeSaveData = recipe.toCreateData()
        
        // Update Recipe
        if self.recipe != nil {
            guard let existingID = self.recipe?.id else {
                let message = "There was an error updating the recipe"
                ErrorPresenter.showError(message: message, on: self)
                return
            }
            RecipeRequest(recipeID: existingID).update(with: recipeSaveData) { result in
                switch result {
                case .failure:
                    let message = "There was a problem updating the recipe"
                    ErrorPresenter.showError(message: message, on: self)
                case .success(let updatedRecipe):
                    self.recipe = updatedRecipe
                    DispatchQueue.main.async { [weak self] in
                        self?.performSegue(withIdentifier: "UpdateRecipeDetails", sender: nil)
                    }
                }
            }
        // Create Recipe
        } else {
            ResourceRequest<Recipe>(resourcePath: "recipes").save(recipeSaveData) { [weak self] result in
                switch result {
                case .failure:
                    let message = "There was a problem saving the recipe"
                    ErrorPresenter.showError(message: message, on: self)
                case .success:
                    DispatchQueue.main.async { [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func unwindToCreateRecipeVC(_ segue: UIStoryboardSegue) {
        guard let controller = segue.source as? SelectUserTableViewController else { return }
        selectedUser = controller.selectedUser
        print(selectedUser ?? "No User")
        createdByUsername.text = selectedUser?.username
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

}
