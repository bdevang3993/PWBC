//
//  AddRecipesTableViewCell.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 09/01/21.
//

import UIKit

class AddRecipesTableViewCell: UITableViewCell {

    @IBOutlet weak var imgRecips: UIImageView!
    @IBOutlet weak var lblRecipsTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        lblRecipsTitle.textColor = hexStringToUIColor(hex: strTheamColor)
        imgRecips.tintColor = hexStringToUIColor(hex: strTheamColor)
    }
    

}
