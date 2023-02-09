//
//  LangaugeListViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 26/01/22.
//

import UIKit
import Localize_Swift

class LangaugeListViewModel: NSObject {
    var tblDisplay:UITableView?
    var arrLanguage = [LangaugeType]()
    var strSelectedCode:String = ""
    var objCustomTableView = CustomTableView()
    let availableLanguages = Localize.availableLanguages()
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    
    func setUpLanguageSelection() {
        self.arrLanguage.removeAll()
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let objLangaugeType = LangaugeType(strTitle: displayName, strCode: language, isSelected: false)
            if !displayName.isEmpty {
                self.arrLanguage.append(objLangaugeType)
            }
        }
        self.tblDisplay?.reloadData()
    }
    
    func setUpSelectedLanguage(strLanguage:String)  {
        let userDefault = UserDefaults.standard
        strSelectedLocal = strLanguage
        strSelectedLanguage = Localize.displayNameForLanguage(strLanguage)
        userDefault.setValue(strSelectedLocal, forKey: kSelectedLocal)
        userDefault.setValue(strSelectedLanguage, forKey: kSelectedLanguage)
        userDefault.synchronize()
        Localize.setCurrentLanguage(strLanguage)
    }
    
    func setUpCellData(cell:BusinessListTableViewCell,index:Int) {
        let data:LangaugeType = numberOfItemAtIndex(index: index)
        cell.lblTitle.text = data.strTitle
        if data.isSelected {
            cell.imgSelect.image = UIImage(systemName: "checkmark.square")
        }else {
            cell.imgSelect.image = UIImage(systemName: "squareshape")
        }
    }
    
    func setupDataSelection(index:Int) {
        for i in 0...self.arrLanguage.count - 1 {
            var data:LangaugeType = self.arrLanguage[i]
            data.isSelected = false
            self.arrLanguage [i] = data
        }
        var data:LangaugeType = numberOfItemAtIndex(index: index)
        if data.isSelected == false {
            data.isSelected = true
        }else {
            data.isSelected = false
        }
        strSelectedCode = data.strCode
        self.arrLanguage[index] = data
        self.tblDisplay!.reloadData()
    }
    
}
extension LangaugeListViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return arrLanguage.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100.0
        } else {
            return 70.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrLanguage[index] as! T
    }
}
