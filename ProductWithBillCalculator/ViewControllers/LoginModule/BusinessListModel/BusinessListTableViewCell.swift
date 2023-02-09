//
//  BusinessListTableViewCell.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 31/08/21.
//

import UIKit

class BusinessListTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.imgSelect.tintColor = hexStringToUIColor(hex: strTheamColor)
    }

}
