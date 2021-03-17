//
//  CreateRecipeTableViewController.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/17/21.
//

import UIKit

class CreateRecipeTableViewController: UITableViewController {
    
    // MARK: - Properties
    var selectedUser: User?
    var recipe: Recipe?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
