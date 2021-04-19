//
//  ShowRecipeTableViewCell.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/22/21.
//

import UIKit

class ShowRecipeTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeRating: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var recipeLikesLabel: UILabel!
    
    // MARK: Properties
    var recipe: Recipe?
    var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: IBActions
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {

        
//        let impactMedium = UIImpactFeedbackGenerator(style: .medium)
//        impactMedium.impactOccurred()
        
    }
    
}
