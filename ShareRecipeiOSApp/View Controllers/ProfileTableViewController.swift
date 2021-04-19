//
//  ProfileTableViewController.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 4/8/21.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    // MARK: Properties
    var authToken: String? {
        didSet {
            if let authToken = authToken {
                DispatchQueue.main.async {
                    self.userRequest.getUser(tokenID: authToken) { [weak self] result in
                        switch result {
                        case .failure:
                            break
                            
                        case .success(let foundUser):
                            self?.user = foundUser
                            print("Set User")
                        }
                    }
                }
            }
        }
    }
    
    var user: User? {
        didSet {
            loadUserRecipes()
        }
    }
    var savedRecipeData: LoadTableViewCellData?
    var startedRecipes: [Recipe] = []
    var finishedRecipes: [Recipe] = []
    var savedRecipes: [Recipe] = [] {
        didSet {
            savedRecipeData = LoadTableViewCellData(recipes: savedRecipes, user: user, tableView: tableView)
        }
    }
    var createdRecipes: [Recipe] = []
    var followedUsers: [User] = []
    let userRequest = UserRequest()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipeCell")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UsersCell")
        navigationItem.hidesBackButton = true
        
        let cellNib = UINib(nibName: "ShowRecipeTableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "ShowRecipeTableViewCell")
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authToken = Auth().token
        
        savedRecipeData = LoadTableViewCellData(recipes: savedRecipes, user: user, tableView: tableView)
    }
    
    func loadUserRecipes() {
        UserRequest().getLikedRecipes(userID: (user!.id!)) { [weak self] result in
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
        
        UserRequest().getCreatedRecipes(userID: (user!.id!)) { [weak self] result in
            switch result {
            case .failure:
                break
//                print("Unable to get recipes user created or user has not created any")
            case .success(let recipes):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.createdRecipes = recipes
                    self.tableView.reloadData()
                }
            }
        }
        
        UserRequest().getStartedRecipes(userID: (user!.id!)) { [weak self] result in
            switch result {
            case .failure:
                break
            case .success(let recipes):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.startedRecipes = recipes
                    self.tableView.reloadData()
                }
            }
        }
        
        UserRequest().getFinishedRecipes(userID: (user!.id!)) { [weak self] result in
            switch result {
            case .failure:
                break
//                print("Unable to get recipes user created or user has not created any")
            case .success(let recipes):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.finishedRecipes = recipes
                    self.tableView.reloadData()
                }
            }
        }
        
        UserRequest().getFollowedUsers(userID: (user!.id!)) { [weak self] result in
            switch result {
            case .failure:
                break
//                print("Unable to get followed users.")
            case .success(let users):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.followedUsers = users
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    // MARK: IBSegueAction
    @IBSegueAction func GetRecipe(_ coder: NSCoder) -> RecipesDetailTableViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return nil
        }
        var recipe: Recipe
        
        switch indexPath.section {
        case 0:
            recipe = startedRecipes[indexPath.row]
        case 1:
            recipe = finishedRecipes[indexPath.row]
        case 2:
            recipe = savedRecipes[indexPath.row]
        case 3:
            recipe = createdRecipes[indexPath.row]
        default:
            recipe = startedRecipes[indexPath.row]
        }
        
        return RecipesDetailTableViewController(coder: coder, recipe: recipe)
    }
    
    // MARK: - IBActions
    
    @IBAction func logout(_ sender: Any) {
        Auth().logout()
        self.navigationController?.popToRootViewController(animated: true)
        self.tabBarController?.tabBar.items?[3].title = "Log in"
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return startedRecipes.count
        case 1:
            return finishedRecipes.count
        case 2:
            return savedRecipes.count
        case 3:
            return createdRecipes.count
        case 4:
            return followedUsers.count
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let workingOnRecipeCell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
            workingOnRecipeCell.textLabel?.text = startedRecipes[indexPath.row].name
            return workingOnRecipeCell
        case 1:
            let usedRecipeCell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
            usedRecipeCell.textLabel?.text = finishedRecipes[indexPath.row].name
            return usedRecipeCell
        case 2:
            if let savedRecipeData = savedRecipeData {
                let savedRecipeCell = savedRecipeData.loadRecipeCell(cellForRowAt: indexPath)
                return savedRecipeCell
            } else {
                return UITableViewCell()
            }
 
        case 3:
            let createdRecipeCell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
            createdRecipeCell.textLabel?.text = createdRecipes[indexPath.row].name
            return createdRecipeCell
        case 4:
            let usersCell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath)
            usersCell.textLabel?.text = followedUsers[indexPath.row].name
            usersCell.detailTextLabel?.text = followedUsers[indexPath.row].username
            return usersCell
        default:
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 1 || indexPath.section == 0 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        } else {
            return super.tableView(tableView, indentationLevelForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 || indexPath.section == 1 || indexPath.section == 0 {
            return 44
        } else if indexPath.section == 2 {
            return 219
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 2 {
//            return 125
//        } else {
//            return 44
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        // A recipe was selected
        switch indexPath.section {
        case 0, 1, 2, 3:
            performSegue(withIdentifier: "ProfileToRecipeDetail", sender: nil)
        case 4:
            // Maybe do something
            let followedUser = followedUsers[indexPath.row]
            print(followedUser)
        default:
            print(indexPath)
        }
    }
    

}
