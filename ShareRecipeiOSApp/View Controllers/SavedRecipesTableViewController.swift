//
//  SavedRecipesTableViewController.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 4/12/21.
//

import UIKit

class SavedRecipesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    var user: User? {
        didSet {
            loadSavedRecipes()
        }
    }
    @IBOutlet weak var notLoggedInTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var noSavesYetLabel: UILabel!
    var savedRecipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        // Login button 
        loginButton.backgroundColor = .systemOrange
        loginButton.layer.cornerRadius = 7.5
        loginButton.layer.borderWidth = 0.3
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.tintColor = .white
    }
    

    
    // MARK: View-Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.popToRootViewController(animated: false)
        self.tabBarController?.selectedIndex = 1
        let userRequest = UserRequest()
        if let authToken = Auth().token {
            self.loginButton.isHidden = true
            self.notLoggedInTextView.text = ""
            userRequest.getUser(tokenID: authToken) { [weak self] result in
                switch result {
                case .failure:
                    DispatchQueue.main.async {
                        
                        self?.loginButton.isHidden = false
                    }
                case .success(let foundUser):
                    self?.user = foundUser
                }
            }
        } else {
            self.loginButton.isHidden = false
            self.notLoggedInTextView.text = "Start planning what you want to make next. As you search, tap the heart icon to save a recipe for later use. Login or create an account to do so."
            user = nil
        }
    }
    
    // MARK: IBActions
    
    @IBAction func loginPressed(_ sender: Any) {
//        performSegue(withIdentifier: "SavedRecipesToLoginScreen", sender: nil)
        self.tabBarController?.selectedIndex = 3
        print("segue performed")
    }
    
    // MARK: Load Data
    
    func loadSavedRecipes() {
        if let user = self.user {
            UserRequest().getLikedRecipes(userID: (user.id!)) { [weak self] result in
                switch result {
                case .failure:
                    print("Unable to get liked recipes")
                case .success(let recipes):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.savedRecipes = recipes
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            savedRecipes = []
            self.tableView.reloadData()
        }

    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(savedRecipes.count)
        return savedRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipeCell = tableView.dequeueReusableCell(withIdentifier: "SavedRecipeCell", for: indexPath)
        recipeCell.textLabel?.text = savedRecipes[indexPath.row].name
        return recipeCell
    }



}
