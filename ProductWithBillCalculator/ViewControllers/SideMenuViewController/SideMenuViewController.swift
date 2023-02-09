//
//  SideMenuViewController.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit

class SideMenuViewController: UIViewController {
    @IBOutlet weak var tblDisplayData: UITableView!
    var objSideMenuViewModel = SideMenuViewModel()
    
    @IBOutlet weak var viewBackground: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tblDisplayData.delegate = self
        tblDisplayData.dataSource = self
        tblDisplayData.tableFooterView = UIView()
        objSideMenuViewModel.setUpDescription()
    }
    override func viewDidAppear(_ animated: Bool) {
        objSideMenuViewModel.setUpDescription()
        self.tblDisplayData.reloadData()
        tblDisplayData.separatorColor = hexStringToUIColor(hex: strTheamColor)
        tblDisplayData.separatorColor =  hexStringToUIColor(hex: strTheamColor)
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
