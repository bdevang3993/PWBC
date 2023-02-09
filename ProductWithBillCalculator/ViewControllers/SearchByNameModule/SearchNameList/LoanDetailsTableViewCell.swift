//
//  LoanDetailsTableViewCell.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/01/21.
//

import UIKit

class LoanDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDeduction: UILabel!
    
    @IBOutlet weak var lblDateofPay: UILabel!
    
    @IBOutlet weak var lblBankName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
