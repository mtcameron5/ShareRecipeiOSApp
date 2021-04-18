//
//  IngredientsTableViewCellTwo.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/21/21.
//

import UIKit

class GenericTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
