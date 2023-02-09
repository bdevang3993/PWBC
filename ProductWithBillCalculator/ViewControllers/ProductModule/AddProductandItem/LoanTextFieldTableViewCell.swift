//
//  LoanTextFieldTableViewCell.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/01/21.
//

import UIKit
typealias taSelectedIndex = (Int) -> Void
typealias tabuttonCallClouser = () -> Void
class LoanTextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelection: UIButton!
    
    @IBOutlet weak var btnCall: UIButton!
    var selectedIndex:taSelectedIndex?
    var callclicked:taSelectedIndex?
   
    @IBOutlet weak var imgDown: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        txtDescription.setLeftPaddingPoints(10.0)
        lblTitle.textColor = hexStringToUIColor(hex: strTheamColor)
        imgDown.tintColor = hexStringToUIColor(hex: strTheamColor)
        self.selectionStyle = .none
    }
    
    @IBAction func btnSelectionClicked(_ sender: UIButton) {
        selectedIndex!(sender.tag)
    }
    
    @IBAction func btnCallClicked(_ sender: UIButton) {
        callclicked!(sender.tag)
    }
    
}
