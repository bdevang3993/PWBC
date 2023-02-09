//
//  TheamPickerViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 20/08/21.
//

import Foundation
import AVFoundation
import Localize_Swift
import Floaty

class TheamPickerViewModel:NSObject {
    var arrColorName = [String]()
    var headerViewXib:CommanView?
    var isFromTheamPickerSpeech:Bool = true
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Setting".localized() //"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
      //  headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(TheamPickerViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    
    func configureColorName() {
        arrColorName.removeAll()
        arrColorName.append(TheamPickerTitle.sky.selectedString())
        arrColorName.append(TheamPickerTitle.red.selectedString())
        arrColorName.append(TheamPickerTitle.orange.selectedString())
        arrColorName.append(TheamPickerTitle.green.selectedString())
        arrColorName.append(TheamPickerTitle.blue.selectedString())
        arrColorName.append(TheamPickerTitle.indigo.selectedString())
        arrColorName.append(TheamPickerTitle.violate.selectedString())
        var string:String = "You can select Theam throught index".localized()
        if isSpeackSpeechOn {
            for i in 0...self.arrColorName.count - 1 {
                string = string + " " + "index is \(i) for " + self.arrColorName[i]
            }
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: string)
        }
    }
    
    func colorName(index:Int) -> String {
        switch index {
        case 0:
            return RainbowColor.main.selectedColor()
        case 1:
            return RainbowColor.red.selectedColor()
        case 2:
            return RainbowColor.orange.selectedColor()
        case 3:
            return RainbowColor.green.selectedColor()
        case 4:
            return RainbowColor.blue.selectedColor()
        case 5:
            return RainbowColor.indigo.selectedColor()
        case 6:
            return RainbowColor.violet.selectedColor()
        default:
            return RainbowColor.main.selectedColor()
        }
    }
    

}
extension TheamPickerViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return objTheamPickerViewModel.arrColorName.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if indexPath.section == 0 {
                return 130.0
            } else {
                return 100.0
            }
            
        } else {
            if indexPath.section == 0 {
                return 100.0
            } else {
                return 70.0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
            cell.lblTitle.text = "Prefer Language".localized()
            cell.txtDescription.text = strSelectedLanguage
            cell.btnCall.isHidden = true
            cell.imgDown.isHidden = false
            cell.selectedIndex = { [weak self] index in
                self!.setUpLanguageSelection(index: index)
            }
            return cell
        } else {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "TheamTableViewCell") as! TheamTableViewCell
            cell.lblColorName.text = objTheamPickerViewModel.arrColorName[indexPath.row] + "Theme".localized()
            let colorString = objTheamPickerViewModel.colorName(index: indexPath.row)
            cell.viewColor.backgroundColor = hexStringToUIColor(hex: colorString)
            if colorString == strTheamColor {
                cell.imgSelectedTheam.isHidden = false
            } else {
                cell.imgSelectedTheam.isHidden = true
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        setAlertWithCustomAction(viewController: self, message: "Are you sure you want to change theam color".localized() + "?", ok: { (isSuccess) in
            self.selectedTheamColor(index: indexPath.row)
        }, isCancel: true) { (isSuccess) in
        }
    }
    func selectedTheamColor(index:Int) {
        let colorString = self.objTheamPickerViewModel.colorName(index: index)
        let colorName = self.objTheamPickerViewModel.arrColorName[index]
        SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "You have selected \(colorName) theam")
        let userDefault = UserDefaults.standard
        userDefault.setValue(colorString, forKey: kTheamColor)
        userDefault.synchronize()
        strTheamColor = colorString
        self.viewBackGroundColor.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.viewHeader.backgroundColor =  hexStringToUIColor(hex: strTheamColor)
        self.tblDisplayData.reloadData()
    }
}
extension TheamPickerViewController {
    
    func setUpListen() {
        let toggleisActive = userDefault.bool(forKey: kSpeach)
        if toggleisActive {
            speachSwitch.setOn(true, animated: false)
        } else {
            speachSwitch.setOn(false, animated: false)
        }
    }
    func setUpSpeak() {
        let isSpeachAccess = userDefault.bool(forKey: kSpeakSpeech)
        if isSpeachAccess {
            speakSpeechSwitch.setOn(true, animated: false)
            isSpeackSpeechOn = true
        } else {
            speakSpeechSwitch.setOn(false, animated: false)
            isSpeackSpeechOn = false
        }
    }
    func setUpLanguageSelection(index:Int) {
        actionSheet = UIAlertController(title: nil, message: "Switch Language".localized(), preferredStyle: UIAlertController.Style.actionSheet)
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            
            let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                    Localize.setCurrentLanguage(language)
                MBProgressHub.showLoadingSpinner(sender: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.setUpSelectedLanguage(strLanguage: language)
                }
               
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    func setUpSelectedLanguage(strLanguage:String)  {
        let userDefault = UserDefaults.standard
        strSelectedLocal = strLanguage
        userDefault.setValue(strSelectedLocal, forKey: kSelectedLocal)
        strSelectedLanguage = Localize.displayNameForLanguage(strLanguage)
        userDefault.setValue(strSelectedLanguage, forKey: kSelectedLanguage)
        if isSpeackSpeechOn {
            SpeachListner.objShared.setUpData(viewController: self)
        }
        userDefault.synchronize()
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(kSideMenuNotification), object: nil)
            self.tblDisplayData.reloadData()
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    func setUpStopForOtherLangauge() {
        Alert().showAlert(message: "Local langauge is not suppoeted by Apple choose other langauge".localized(), viewController: self)
        userDefault.set(false, forKey: kSpeakSpeech)
        userDefault.synchronize()
        self.setUpSpeak()
        SpeachListner.objShared.setUpStopData()
        userDefault.set(false, forKey: kSpeach)
        userDefault.synchronize()
        self.setUpListen()
    }
}
extension TheamPickerViewController: FloatyDelegate {
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        
        floaty.addItem(SideMenuTitle.speak.selectedString(), icon: UIImage(named: "mic")) {item in
            SpeachListner.objShared.viewController = self
            self.setUpSpeechData()
        }
        self.view.addSubview(floaty)
    }
    func setUpSpeechData() {
        DispatchQueue.main.async {
            SpeachListner.objShared.selectedString = { [weak self] result in
                self?.filerStringValue(strValue: result)
            }
            SpeachListner.objShared.setUpSpeackRecognizer()
        }
    }
    
    func filerStringValue(strValue:String) {
        let split = strValue.split(separator: " ")
        let lastTwo = String(split.suffix(2).joined(separator: [" "]))
        let strnewItemName = String(split.suffix(1).joined(separator: [" "])).prefix(2)
        var isDataMatch:Bool = false
        
        
        let newData = strValue.lowercased().components(separatedBy: "Listen".localized().lowercased())
        if newData.count > 1 && objTheamPickerViewModel.isFromTheamPickerSpeech {
            if let range = strValue.lowercased().range(of: "Listen".localized().lowercased()) {
                let value:String = String(strValue[range.upperBound...])
                if value.lowercased().contains("On".localized().lowercased()) {
                    userDefault.set(true, forKey: kSpeach)
                    userDefault.synchronize()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.objTheamPickerViewModel.isFromTheamPickerSpeech = true
                    }
                    self.setUpListen()
                    isDataMatch = true
                    return
                } else if value.lowercased().contains("Off".localized().lowercased()) ||  value.lowercased().contains("Up".lowercased()) {
                    isDataMatch = true
                    userDefault.set(false, forKey: kSpeach)
                    userDefault.synchronize()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.objTheamPickerViewModel.isFromTheamPickerSpeech = true
                    }
                    self.setUpListen()
                    return
                }
            }
        }
        
        let speakData = strValue.lowercased().components(separatedBy: "Speak".localized().lowercased())
        if  objTheamPickerViewModel.isFromTheamPickerSpeech && isDataMatch == false && speakData.count > 1 {
            for value in speakData {
                let newValue = removeWhiteSpace(strData: value)
                if newValue.lowercased().contains("On".localized().lowercased()) {
                    userDefault.set(true, forKey: kSpeakSpeech)
                    userDefault.set(true, forKey: kSpeach)
                    userDefault.synchronize()
                    self.setUpListen()
                    self.setUpSpeak()
                    self.setUpSpeechData()
                    isDataMatch = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.objTheamPickerViewModel.isFromTheamPickerSpeech = true
                    }
                    return
                } else if newValue.lowercased().contains("Off".localized().lowercased()) || value.lowercased().contains("Up".lowercased()) {
                    userDefault.set(false, forKey: kSpeakSpeech)
                    userDefault.synchronize()
                    self.setUpSpeak()
                    SpeachListner.objShared.setUpStopData()
                    isDataMatch = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.objTheamPickerViewModel.isFromTheamPickerSpeech = true
                    }
                    return
                }
            }
        }
        
        let languageData = strValue.lowercased().components(separatedBy: "Language".localized().lowercased())
        if languageData.count > 1 && objTheamPickerViewModel.isFromTheamPickerSpeech && isDataMatch == false {
            var languageMatch:Bool = false
            for value in languageData {
                let newvalue = removeWhiteSpace(strData: value)
                for language in availableLanguages {
                    if newvalue.lowercased().contains(language.lowercased()) {
                        //                    let displayName = Localize.displayNameForLanguage(language)
                        languageMatch = true
                        Localize.setCurrentLanguage(language)
                        MBProgressHub.showLoadingSpinner(sender: self.view)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.setUpSelectedLanguage(strLanguage: language)
                        }
                        
                    }
                }
            }
            if languageMatch == false {
                var strLangauge:String = "please choose one language from list".localized()
                for language in availableLanguages {
                    let displayName = Localize.displayNameForLanguage(language)
                    strLangauge = strLangauge + " " + displayName
                }
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strLangauge)
                return
            }
        }

        
        let data = strValue.lowercased().components(separatedBy: "Index".localized().lowercased())
        if data.count > 1 && objTheamPickerViewModel.isFromTheamPickerSpeech && isDataMatch == false {
            if let range = strValue.lowercased().range(of: "Index".localized().lowercased()) {
                let value:String = String(strValue[range.upperBound...])
                print("data = \(data)")
                if !data.last!.isEmpty && value.count > 0 {
                    var lastValue:String = removeWhiteSpace(strData: data.last!)
                    if  !lastValue.isNumeric {
                        lastValue =  String(split.suffix(1).joined(separator: [" "]))
                        let number = lastValue.spelled
                        if !lastValue.contains("ze")  && number == 0 {
                            return
                        }
                        lastValue = String(number)
                        objTheamPickerViewModel.isFromTheamPickerSpeech = false
                        if objTheamPickerViewModel.arrColorName.count > number {
                            isDataMatch = true
                            self.selectedTheamColor(index: number)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.objTheamPickerViewModel.isFromTheamPickerSpeech = true
                            }
                            return
                        } else {
                            return
                        }
                    }
                }
            }
        }
        
//        var arrData = self.objTheamPickerViewModel.arrColorName.filter{$0.lowercased().contains(strnewItemName.lowercased())}
//        if arrData.count > 1 {
//            arrData.removeLast()
//        }
//        if strnewItemName.lowercased() == "go" || strnewItemName.lowercased() == "open" {
//            arrData.removeAll()
//        }
//        if arrData.count == 1 && objTheamPickerViewModel.isFromTheamPickerSpeech && isDataMatch == false {
//            objTheamPickerViewModel.isFromTheamPickerSpeech = false
//            let name = arrData[0]
//            for i in 0...self.objTheamPickerViewModel.arrColorName.count - 1 {
//                if name == self.objTheamPickerViewModel.arrColorName[i] {
//                    self.selectedTheamColor(index: i)
//                    isDataMatch = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                        self.objTheamPickerViewModel.isFromTheamPickerSpeech = true
//                    }
//                    return
//                }
//            }
//        }
    }
}
