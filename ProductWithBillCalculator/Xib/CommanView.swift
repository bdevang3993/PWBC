//
//  CommanView.swift
//  XibDemo
//
//  Created by devang bhavsar on 06/01/21.
//  Copyright © 2021 devang bhavsar. All rights reserved.
//

import UIKit

class CommanView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnHeader: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblBack: UILabel!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var layoutConstraintbtnCancelLeading: NSLayoutConstraint!
    public override init(frame: CGRect) {
             super .init(frame: frame)
         }
         required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
         }
      
     func instanceFromNib() -> CommanView {
     return UINib(nibName: "CommanView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! CommanView
        }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
