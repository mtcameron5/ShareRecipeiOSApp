//
//  CreateRecipeTableViewController.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/17/21.
//

import UIKit

class CreateRecipeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var recipeServings: UITextField!
    @IBOutlet weak var recipeCookTime: UITextField!
    @IBOutlet weak var recipePrepTime: UITextField!
    @IBOutlet weak var createdByUsername: UITextField!
    @IBOutlet var recipeImage: UIImageView!
    
    
    // MARK: - Properties
    var selectedUser: User?
    var recipe: Recipe?
    var recipeIngredients: [String] = []
    var recipeInstructions: [String] = []
    var imagePicker = UIImagePickerController()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add delegate to each text field
        let textFieldDelegate = TextFieldDelegate()
        recipeName.delegate = textFieldDelegate
        
        if let recipe = recipe {
            recipeName.text = recipe.name
            recipeIngredients = recipe.ingredients
            recipeInstructions = recipe.directions
            recipeServings.text = "\(recipe.servings)"
            recipeCookTime.text = recipe.cookTime
            recipePrepTime.text = recipe.prepTime
            createdByUsername.text = selectedUser?.name
            navigationItem.title = "Edit Recipe"
        } else {
            populateUser()
        }
        
        tableView.register(UINib(nibName: "GenericTableViewCell", bundle: nil), forCellReuseIdentifier: "GenericTableViewCell")
        tableView.register(UINib(nibName: "InstructionsTableViewCell", bundle: nil), forCellReuseIdentifier: "InstructionsTableViewCell")
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
    
    @IBSegueAction func addIngredients(_ coder: NSCoder) -> UITableViewController? {
        return CreateRecipeIngredientsListTableViewController(coder: coder, ingredients: recipeIngredients)
    }
    
    @IBSegueAction func addInstructions(_ coder: NSCoder) -> UITableViewController? {
        return CreateRecipeInstructionsTableViewController(coder: coder, directions: recipeInstructions)
    }
    
    
    // MARK: - IBActions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveToDatabase(_ sender: UIBarButtonItem) {
        // Checks before attempting to save to database
        guard let recipeNameText = recipeName.text, !recipeNameText.isEmpty else {
            let message = "You must give the recipe a name."
            ErrorPresenter.showError(message: message, on: self)
            return
        }
        
        if recipeIngredients.isEmpty {
            let message = "You must have ingredients for your recipe"
            ErrorPresenter.showError(message: message, on: self)
            return
        }
        
        if recipeInstructions.isEmpty {
            let message = "You must have instructions for your recipe"
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
        
        
        let recipe = Recipe(userID: userID, name: recipeNameText, ingredients: recipeIngredients, directions: recipeInstructions, servings: recipeServingsInt, cookTime: recipeCookTimeText, prepTime: recipePrepTimeText)
        let recipeSaveData = recipe.toCreateData()

        // Update Recipe
        if self.recipe?.id != nil {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        self.recipeImage = UIImageView(image: newImage)
        print(newImage)
        dismiss(animated: true, completion: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
    }
    @IBAction func takePicture(_ sender: Any) {
        print("Take picture pressed")
    }
    
    @IBAction func selectImageFromPhotoAlbum(_ sender: Any) {
        print("Select image from photo album pressed")
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func unwindToCreateRecipeVC(_ segue: UIStoryboardSegue) {
        guard let controller = segue.source as? SelectUserTableViewController else { return }
        selectedUser = controller.selectedUser
        createdByUsername.text = selectedUser?.username
    }
    
    @IBAction func getIngredients(_ segue: UIStoryboardSegue) {
        guard let controller = segue.source as? CreateRecipeIngredientsListTableViewController else { return }
        recipeIngredients = controller.ingredients
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func getDirections(_ segue: UIStoryboardSegue) {
        guard let controller = segue.source as? CreateRecipeInstructionsTableViewController else { return }
        recipeInstructions = controller.directions
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 3 {
            return self.recipeIngredients.count
        } else if section == 5 {
            return self.recipeInstructions.count
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell") as! GenericTableViewCell
            cell.ingredientName.text = recipeIngredients[indexPath.row]
            return cell
        } else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionsTableViewCell") as! InstructionsTableViewCell
            cell.instructionsText.text = recipeInstructions[indexPath.row]
            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
 
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 3 || indexPath.section == 5 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 || indexPath.section == 5 {
            return 44
        } else if indexPath.section == 0 {
            return 200
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    

    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.orange
    }

}

