//
//  FooterTableViewCell.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 08/01/21.
//

import UIKit

class FooterTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        lblTotalAmount.text = "Total Amount Spent".localized()
        lblTotalPrice.textColor = hexStringToUIColor(hex: strTheamColor)
        lblTotalAmount.textColor = hexStringToUIColor(hex: strTheamColor)
        self.selectionStyle = .none
    }

}
