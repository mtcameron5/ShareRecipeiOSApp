//
//  CreateRecipeIngredientsListTableViewController.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/21/21.
//

import UIKit

class CreateRecipeIngredientsListTableViewController: UITableViewController {
    
    // MARK: Properties
    var ingredients: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }


}
