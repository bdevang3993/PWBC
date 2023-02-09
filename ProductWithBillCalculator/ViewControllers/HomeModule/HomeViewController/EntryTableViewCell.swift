//
//  EntryTableViewCell.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 08/01/21.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblItemType: UILabel!
    @IBOutlet weak var lblItemDetails: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
