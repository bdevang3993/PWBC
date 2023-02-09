//
//  TheamTableViewCell.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 20/08/21.
//

import UIKit

class TheamTableViewCell: UITableViewCell {

    @IBOutlet weak var lblColorName: UILabel!
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var imgSelectedTheam: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.setUpView()
    }
    
    func setUpView() {
        viewColor.layer.cornerRadius = viewColor.frame.width/2
        viewColor.layer.masksToBounds = true
        viewColor.layer.borderWidth = 1.0
        viewColor.layer.borderColor = UIColor.black.cgColor
        viewColor.layoutIfNeeded()
    }

}
