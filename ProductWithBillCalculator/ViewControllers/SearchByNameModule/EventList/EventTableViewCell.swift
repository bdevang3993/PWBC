//
//  EventTableViewCell.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 11/08/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDays: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
